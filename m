From: Kurt Garloff <garloff@suse.de>
Subject: Re: Suse Linux Professional 7.2
Date: Thu, 9 May 2002 01:32:25 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020509013225.G23476@gum01m.etpnet.phys.tue.nl>
References: <3CD98245.EBDF5B6F@milleraa.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cyV/sMl4KAhiehtf"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3CD98245.EBDF5B6F@milleraa.com>
List-Id: linux-scsi@vger.kernel.org
To: Eddie Johnson <ejohnson@milleraa.com>
Cc: linux-scsi@vger.kernel.org


--cyV/sMl4KAhiehtf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eddie,

On Wed, May 08, 2002 at 03:53:41PM -0400, Eddie Johnson wrote:
> I have set up a suse linux 7.2 professional on a HP netserver LC3
> PII/450.  The OS is on the raid channel 0.  I also have a scsi drive
> attached on another channel.  The drive has been formatted so I am
> trying to figure out how to get the OS to recognize the new drive using
> stored commands, utilities, or packages.

The extra SCSI drive is attached to another SCSI channel on the same raid
controller?
Is the drive handled by the RAID controller in some RAIDish way or is it
just made available to the OS without further intervention?
What is the RAID controller you use? (In doubt check with lspci.)
Does it show as two SCSI controllers? Maybe an additional ncr/sym/lsi53c8xx=
?=20

Can you see the drive with cat /proc/scsi/scsi ?
If yes, it wil be available under /dev/sdX where X is something between b an
z. Have a look at /var/log/boot.msg: Upon loading of the controller, you'll
get some information displayed and below the detection of SCSI drives.

> I think if I did a reinstallation of the OS that the drive will show but I

Confess: You've been in the Windoze world for too long?

But maybe you will want to have a look at hwinfo.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--cyV/sMl4KAhiehtf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE82bWJxmLh6hyYd04RAh3iAJ4ud2LWfG7sCRlPdO41BkygcPreqgCcC2Ti
0CKLOhXzkld0ineqByG4k+o=
=AQ2y
-----END PGP SIGNATURE-----

--cyV/sMl4KAhiehtf--
