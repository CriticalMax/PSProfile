<!DOCTYPE html>
<html>
<head>
	<title>Slyfa</title>
	<link rel="shortcut icon" type="image/png" href="img/favicon.png">
	<meta charset="utf8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
	<link rel="stylesheet" href="style.css">
	<link href="https://fonts.googleapis.com/css?family=Lato" rel="stylesheet">

	<script src="https://code.jquery.com/jquery-3.1.1.min.js" integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8=" crossorigin="anonymous"></script>
	<!-- Latest compiled and minified JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
</head>

<body>

<?php
	//include_once 'header.php';
?>
	
	<div class="steam-header" id="top">
		<?php 
			$api_url = 'https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key=F9D44C53073F735013F7480F56BDEF49&format=json&steamids=76561198103268207';
			$json = json_decode(file_get_contents($api_url), true);
			$picture_url = $json["response"]["players"][0]["avatarfull"];
			$profilename = $json["response"]["players"][0]["personaname"];
			echo "<img class='img-responsive' id='profile-picture' src=$picture_url alt='steam-profile' width='150' height='150'>";
			echo "<p class='profile-name'>$profilename</p>";
		?>
	</div>
	<div class="steam-profile">
		<div class="steam-gallery">
			<p class="gallery-text">Gallery</p>
			<!--<a href="http://www.schleckysilberstein.com/wp-content/uploads/2015/10/Bildschirmfoto-2015-10-05-um-08.47.57.jpg"><img class="img-responsive gallery" src="img/slyfu.gif" alt=""></a>-->
			<div id="myCarousel" class="carousel slide gallery" data-ride="carousel">
				<!-- Indicators -->
				<ol class="carousel-indicators">
					<li data-target="#myCarousel" data-slide-to="0" class="active"></li>
					<li data-target="#myCarousel" data-slide-to="1"></li>
					<li data-target="#myCarousel" data-slide-to="2"></li>
					<li data-target="#myCarousel" data-slide-to="3"></li>
				</ol>

				<!-- Wrapper for slides -->
				<div class="carousel-inner">
					<div class="item active">
						<img src="img/slyfu.gif" alt="FU" >
					</div>

					<div class="item">
						<a target="_blank" href="https://steamuserimages-a.akamaihd.net/ugc/97234068383204621/BAB24ECC48A1C8B4C3DFC8CAFB8447C69B7BF993/"/><img src="https://steamuserimages-a.akamaihd.net/ugc/97234068383204621/BAB24ECC48A1C8B4C3DFC8CAFB8447C69B7BF993/" alt="Baba"></a>
					</div>

					<div class="item">
						<a target="_blank" href="https://steamuserimages-a.akamaihd.net/ugc/279598939718673834/EFD159C9712497B2C8914267E9DEBF9080FD9E4C/"><img src="https://steamuserimages-a.akamaihd.net/ugc/279598939718673834/EFD159C9712497B2C8914267E9DEBF9080FD9E4C/" alt="Rocket"></a>
					</div>

					<div class="item">
						<a target="_blank" href="https://steamuserimages-a.akamaihd.net/ugc/432699760866690848/D8543E6EB41011793AAEA1036FA97CE76C573B50/"><img src="https://steamuserimages-a.akamaihd.net/ugc/432699760866690848/D8543E6EB41011793AAEA1036FA97CE76C573B50/" alt="Rank"></a>
					</div>
				</div>
				
				<!-- Left and right controls -->
				<a class="left carousel-control" href="#myCarousel" data-slide="prev">
					<span class="glyphicon glyphicon-chevron-left"></span>
					<span class="sr-only">Previous</span>
				</a>
				<a class="right carousel-control" href="#myCarousel" data-slide="next">
					<span class="glyphicon glyphicon-chevron-right"></span>
					<span class="sr-only">Next</span>
				</a>
				</div>
		</div>
		<div class="steam-sidebar">
				<?php 
					$api_url = 'https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key=F9D44C53073F735013F7480F56BDEF49&format=json&steamids=76561198103268207';
					$json = json_decode(file_get_contents($api_url), true);
					$status = $json["response"]["players"][0]["personastate"];
					$playing = $json["response"]["players"][0]["gameextrainfo"];
					if(empty($playing))
					{
						switch($status) {
							case 0:
								echo "<p id='online-state' style='color: white;'>Currently offline</p>";
								break;
							case 1:
								echo "<p id='online-state' style='color: rgb(27, 171, 255);'>Currently online</p>";
								break;
							case 2:
								echo "<p id='online-state' style='color: white;'>Currently Busy</p>";
								break;
							case 3:
								echo "<p id='online-state' style='color: white;'>Currently Away</p>";
								break;
							case 4:
								echo "<p id='online-state' style='color: white;'>Snooze</p>";
								break;
							case 5:
								echo "<p id='online-state' style='color: white;'>Looking to trade</p>";
								break;
							case 6:
								echo "<p id='online-state' style='color: white;'>Looking to play</p>";
								break;
							default:
								echo "<p id='online-state' style='color: white;'>Unknown status</p>";
						}
					}
					else
					{
						echo "<p id='online-state' style='color: rgb(30, 255, 0);'>Currently In-Game</p>";
						echo "<p id='online-state' style='font-size: 14px;margin-top:40px;color: rgb(30, 255, 0);'>$playing</p>";
						echo "<br>";
						echo "<br>";
					}
				?>
			<br>
			<br>
			<a href='http://steamcommunity.com/id/Slyfa/inventory/#730'><p id="online-state" style='color: white;'>Inventory</p></a>
			<br>
			<br>
			<p id="online-state" onclick="toggleDropdown();" style="color: white; cursor: pointer;">Other Stuff &#9776;</p>
			<div id="dropdown-games" style="display: none;">
				<a target="_blank" href="https://fortnitetracker.com/profile/pc/Slyfa"><p id="online-state" style="color: rgb(27, 171, 255);">Fortnite</p></a>
				<br>
				<br>
				<a href=""><p id="online-state" style="color: rgb(27, 171, 255);">Origin</p></a>
				<br>
				<br>
				<a href=""><p id="online-state" style="color: rgb(27, 171, 255);">battle.net</p></a>
			</div>
			<br>
			<br>
			<a href="http://steamcommunity.com/id/Slyfa/"><p id="online-state" style='color: white;'>Back to Steam</p></a>
		</div>
		<div class="steam-card">
			<p class="gallery-text" id="jumpto-config">Config</p>
			<div id="config">
				<p id="config-text">
				// ======== VIEWMODEL =======
				<br>
				<br>
				cl_viewmodel_shift_left_amt "0.500000"
				<br>
				cl_viewmodel_shift_right_amt "0.250000"
				<br>
				viewmodel_fov "68.000000"
				<br>
				viewmodel_offset_x "2.500000"
				<br>
				viewmodel_offset_y "2.0"
				<br>
				viewmodel_offset_z "-2.000000"
				<br>
				viewmodel_presetpos "0"
				<br>
				cl_bob_lower_amt "5.000000"
				<br>
				cl_bobamt_lat "0.100000"
				<br>
				cl_bobamt_vert "0.100000"
				<br>
				cl_bobcycle "0.98"
				<br>
				<br>
				// ========= AUDIO =========
				<br>
				<br>
				voice_mixer_volume "1"
				<br>
				<br>
				// ===== JUMPTHROWBIND ======
				<br>
				<br>
				alias +jumpthrow "+jump;-attack"
				<br>
				alias -jumpthrow "-jump"
				<br>
				bind n +jumpthrow
				<br>
				<br>
				// ===== OTHER COMMANDS ======
				<br>
				<br>
				fps_max 0
				<br>
				cl_forcepreload "1"
				<br>
				cl_interp "0"
				<br>
				cl_interp_ratio "1"
				<br>
				cl_cmdrate "128"
				<br>
				cl_updaterate "128"
				<br>
				rate "128000"
				<br>
				snd_mixahead "0.05"
				<br>
				snd_musicvolume "0"
				<br>
				snd_headphone_pan_exponent "2"
				<br>
				snd_headphone_pan_radial_weight "1"
				<br>
				snd_rear_headphone_position "90"
				<br>
				sensitivity "2.0"
				<br>
				<br>
				alias +toggleside "cl_righthand 0"
				<br>
				alias -toggleside "cl_righthand 1"
				<br>
				bind "alt" +toggleside
				<br>
				clear
				<br>
				<br>
				echo "Loaded Slyfa Autoexec"
				<br>
				echo
				<br>
				sensitivity
				<br>
				fps_max
				</p>
			</div>
		</div>
	</div>

	<a href="#top" id="scroll-top-btn" ><span class="glyphicon glyphicon-chevron-up" aria-hidden="true"></span></a> 

	<script>	
		// When the user scrolls down 20px from the top of the document, show the button
		window.onscroll = function() {scrollFunction()};

		function scrollFunction() {
			if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
				document.getElementById("scroll-top-btn").style.display = "block";
			} else {
				document.getElementById("scroll-top-btn").style.display = "none";
			}
		};

		function toggleDropdown() {
			if (document.getElementById('dropdown-games').style.display === "none") {
				document.getElementById('dropdown-games').style.display = "block";
			} else {
				document.getElementById('dropdown-games').style.display = "none";
			}
		};
	</script>
</body>
</html>