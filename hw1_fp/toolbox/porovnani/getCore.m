function core = getCore(singularPoints)

[ydb ydbind] = sort(singularPoints(:,2));
xdb = singularPoints(ydbind,1);
core = [xdb(1); ydb(1)];