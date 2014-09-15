CREATE FUNCTION sq(a int) RETURNS int AS $$
  return a * a;
$$ LANGUAGE plv8;

SELECT sq(2);
