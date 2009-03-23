
{

	sub out {
		my (@strs) = @_;
		print @strs;
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
		my ($weaks) = @_;
		return @$weaks ? 2 : 1;
	}

}

name: /\w+/

desc: /<([^>])>/ { $return = $1; }

attrs: 'attr' attr[@arg](s?) |	

attr: name '!'(?) comp_attrs
	{
		my ($from_name) = (@arg);
		my @options;
		if (has_option($item[2], '!')) {
			push @options, 'style=filled', 'fillcolor=#cccccc';
		}
		out_box($item{'name'}, 'ellipse', 1, @options);
	}

comp_attrs: 
		'(' attr(s?) ')' { $return = $2; }
	|	{ $return = []; }

entity: 'weak'(?) 'entity' name attrs[$item{'name'}]
	{
		out_box($item{'name'}, 'box', weak_peri($item[1]));
	}

relate: 'weak'(?) 'relate' name 
				rel_entity[$item{'name'}, weak_peri($item[1])](s?) 
				attrs[$item{'name'}]
	{
		out_box($item{'name'}, 'diamond', weak_peri($item[1]));
	}

rel_entity: name ('!' | '*')(s?) desc(?)
	{
		my ($from_name, $peri) = (@arg);
		my $options = $item[2];
		my @options;
		push @options, 'arrowhead=normal' unless has_option($options, '*');
		push @options, 'style=bold' if has_option($options, '!');
		if (@$desc) {
			push @options, ('label=' . $item[3]->[0]);
		}
		my $multi = has_option($item[2], '*');
		out "$from_name -- $item{'name'}";
		out '[', join(',', @options), ']' if @options;
		outln ';';
		out_box($item{'name'}, 'box', $peri);
	}

file: (entity | relate)(s?)

