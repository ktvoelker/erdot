
{

	my $out;

	sub out {
		my (@strs) = @_;
		foreach (@strs) {
			$out .= $_;
		}
	}

	sub outln {
		my (@strs) = @_;
		out @strs, "\n";
	}

	sub has_option ($$) {
		my ($options, $option) = @_;
		return scalar grep { $_ eq $option } @$options;
	}

	sub out_box ($$$@) {
		my ($name, $shape, $peri, @options) = @_;
		outln 
			"$name [" . 
			join(',', "shape=$shape", "peripheries=$peri", @options) . 
			'];';
	}

	sub weak_peri ($) {
		my ($weak) = @_;
		return $weak eq 'weak' ? 2 : 1;
	}

}

name: ...!'attr' /\w+/

desc: /<([^>]*)>/ { $return = $1; }

attrs: ('attr' attr[@arg](s?))(?)

attr: name ('!')(?) comp_attrs[$item{'name'}]
	{
		my ($from_name) = (@arg);
		my @options;
		if (has_option($item[2], '!')) {
			push @options, 'style=filled', 'fillcolor="#cccccc"';
		}
		out_box $item{'name'}, 'ellipse', 1, @options;
		out "$from_name -- $item{'name'}";
		#out ' [len=1]';
		outln ';';
	}

comp_attrs: ('(' attr[@arg](s?) ')')(?)

weak: /(weak)?/

entity: weak 'entity' name attrs[$item{'name'}]
	{
		out_box $item{'name'}, 'box', weak_peri($item[1]);
	}

relate: strong_relate | weak_relate

strong_relate: 
	'relate' name rel_entity[$item{'name'}, 1](s?) attrs[$item{'name'}]
	{
		out_box $item{'name'}, 'diamond', 1;
	}

weak_relate: 
	'weak' 'relate' name 
	rel_entity[$item{'name'}, 1] rel_entity[$item{'name'}, 2]
	attrs[$item{'name'}]
	{
		out_box $item{'name'}, 'diamond', 2;
	}

rel_entity: name ('!' | '*')(s?) desc(?)
	{
		my ($from_name, $peri) = (@arg);
		my $desc = $item[3];
		my $options = $item[2];
		my @options;
		#push @options, ('len=1.2');
		my $line_count = has_option($options, '!') ? 2 : 1;
		my @traverse;
		push @traverse, $from_name;
		if (@$desc) {
			push @traverse, $desc->[0];
			out_box $desc->[0], 'box', 0, 'fontsize=12';
		}
		push @traverse, $item{'name'};
		foreach (1 .. $line_count) {
			while (@traverse >= 2) {
				my $from = shift @traverse;
				my $to = $traverse[0];
				push @options, 'arrowhead=normal' 
					if @traverse < 2 && !has_option($options, '*');
				out "$from -- $to";
				out '[', join(',', @options), ']' if @options;
				outln ';';
			}
		}
		out_box $item{'name'}, 'box', $peri;
	}

file: 
	{
		outln 'graph er {';
		outln 'overlap=false;';
		#outln 'page="8.5,11";';
		outln 'size="10.5,8.0";';
		outln 'page="11.0,8.5";';
		outln 'margin="0.25";';
	}
	(entity | relate)(s? /;/)
	{
		outln '}';
		print $out;
	}

