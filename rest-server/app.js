var express = require('express');
var bodyParser = require('body-parser');
var app = express();
var pg = require('pg');

var port = parseInt(process.env.PORT) || 5000;

var conString = process.env.DATABASE_URL || 'postgres://guest:guest@ec2-54-174-131-75.compute-1.amazonaws.com/pwas';

function validQuery(query) {
  if (!query.hasOwnProperty('x')) {
    return 'Query error: no x param';
  }
  if (!isInt(query.x)) {
    return 'Query error: x should be an int';
  }
  if (!query.hasOwnProperty('y')) {
    return 'Query error: no y param';;
  }
  if(!isInt(query.y)) {
    return 'Query error: y should be an int';
  }
  if (!query.hasOwnProperty('s')) {
    return 'Query error: no s param';;
  }
  if(!isInt(query.s)) {
    return 'Query error: s should be an int';
  }
  if (!query.hasOwnProperty('l')) {
    return 'Query error: no l param';;
  }
  if(!isInt(query.l)) {
    return 'Query error: l should be an int';
  }
  if (!query.hasOwnProperty('h')) {
    return 'Query error: no h param';;
  }
  if(!isInt(query.h)) {
    return 'Query error: h should be an int';
  }
  if(query.h > 100 || query.l > 100 || query.h < 0 || query.l < 0) {
    return 'Query error: age (l or h) must be greater or equal to 0 and less than or equal to 100'
  }
  return false;
}

function isInt(value) {
  return !isNaN(value) &&
    parseInt(Number(value)) == value &&
    !isNaN(parseInt(value, 10));
}

app.get('/api/pair_cov', function (req, res) {
  console.log('API reached');
  var results = [];

  var queryError = validQuery(req.query);

  if(queryError) {
    return res.json({
      success: false,
      data: queryError
    });
  }

  pg.connect(conString, function (err, client, done) {
    if (err) {
      console.error(err);
      done();
      return res.status(500).json({
        success: false,
        data: err
      });
    }

    client.query('SELECT SUM(N) FROM patient_counts WHERE SEX=$1 AND AGE>=$2 AND AGE<$3;', [1, 10, 20], function (err, result) {
      done();
      if (err) {
        console.error(err);
        return;
      }

      var n = result.rows[0].sum;
      console.log('n: ' + n);

      client.query('WITH pid_x AS (' +
        'SELECT DISTINCT PID FROM patients WHERE ICD=$1 AND SEX=$3 AND AGE>=$4 AND AGE<$5 GROUP BY PID' +
        '), pid_y AS (' +
        'SELECT DISTINCT PID FROM patients WHERE ICD=$2 AND SEX=$3 AND AGE>=$4 AND AGE<$5 GROUP BY PID' +
        ')' +
        'SELECT' +
        '(SELECT COUNT(PID) FROM pid_x) AS kx,' +
        '(SELECT COUNT(PID) from pid_y) as ky,' +
        '(SELECT COUNT(pid_x.PID) FROM pid_x, pid_y WHERE pid_x.PID=pid_y.PID) as kxy', [5243, 7080, 1, 10, 20], function (err, result) {
          done();
          if (err) {
            console.error(err);
            return;
          }

          var kx = result.rows[0].kx;
          var ky = result.rows[0].ky;
          var kxy = result.rows[0].kxy;

          console.log('kx: ' + kx);
          console.log('ky: ' + ky);
          console.log('kxy: ' + kxy);

          var cov = (n * kxy - kx * ky) / (n * (n - 1));

          return res.json({
            success: true,
            data: {
              cov: cov,
              n: n,
              kx: kx,
              ky: ky,
              kxy: kxy
            }
          });
        });
    });
  });
});

var server = app.listen(port, function () {
  console.log('Server listening at port ' + port);
});
