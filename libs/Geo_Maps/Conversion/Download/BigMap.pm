package Homyaki::Geo_Maps::Conversion::Download::BigMap;

use strict;

use File::Copy;
use Math::Complex;

use Homyaki::Geo_Maps::Conversion::Download::Constants;
use Homyaki::Geo_Maps::Conversion::Map::Ozi_To_Flat;
 
use Data::Dumper;

use base 'Homyaki::Geo_Maps::Conversion';

sub convert {
	my $self = shift;
	my %h = @_;

	my $maps = $h{maps};

	my $geo_data  = $self->{params}->{geo_data};
	my $maps_path = $self->{params}->{maps_path};

	my $www_path  = &MAPS_DESTANTION;

	Homyaki::Geo_Maps::Conversion::Map::Ozi_To_Flat->convert(
		maps       => $maps,
		geo_data  => $geo_data,
		maps_path => $maps_path,
		map_data_save_method => sub {
			my %h = @_;

			my $chunks = $h{chunks};
			my $chunks_data = $h{chunks_data};

			open MAP_KOORD, ">$www_path/$maps_path/$chunks_data->{path}/map_koord.txt";
			my $geo_chunk_scale = sprintf("%d", $chunks_data->{scale_calculated_abs} * 2817.947378);

			foreach my $chunk (@{$chunks}){
				my $geo_chunk_lon = 
					$geo_data->{selected_square}->[0];

				my $geo_chunk_lat = 
					$geo_data->{selected_square}->[3];

				my $chunk_map_file_name = "top_$chunks_data->{type}_$chunks_data->{scale}_${geo_chunk_lat}_${geo_chunk_lon}.jpg";
				
				my $error = $chunk->{image}->Write("$www_path/$maps_path/$chunks_data->{path}/$chunk_map_file_name");

				Homyaki::Logger::print_log("Download::BigMap Error: creation $www_path/$maps_path/$chunks_data->{path}/$chunk_map_file_name : $error");

				print MAP_KOORD "$chunk->{path}/$chunk_map_file_name $geo_chunk_lat $geo_chunk_lon $geo_chunk_scale\n";
			}
			close MAP_KOORD;
		}
	);
	
}

1;
