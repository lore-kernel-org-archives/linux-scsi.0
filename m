From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/2] [SCSI] pm8001: Fix bogus interrupt state flag issue.
Date: Mon, 27 Feb 2012 09:55:18 +0300
Message-ID: <20120227065518.GD4763@mwanda>
References: <1330263210-25134-1-git-send-email-santoshprasadnayak@gmail.com>
 <20120226150720.GB4763@mwanda>
 <CAOD=uF4VGsM5AQTSCW4ZRr_n4HUSr0qO3fG_MAtsYgq=ogXvAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OROCMA9jn6tkzFBc"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOD=uF4VGsM5AQTSCW4ZRr_n4HUSr0qO3fG_MAtsYgq=ogXvAQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: santosh prasad nayak <santoshprasadnayak@gmail.com>
Cc: jack_wang@usish.com, lindar_liu@usish.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--OROCMA9jn6tkzFBc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Sorry, I misread the code.  I thought we were trying to nest
spin_lock_irq() for but we're not.  My mistake.

regards,
dan carpenter



--OROCMA9jn6tkzFBc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPSyjVAAoJEOnZkXI/YHqRW24P/R2lvRvPrITVOdu4GzbE+duN
Rat3ShQBnhLCrRbXd0uoBOb2mUGoCpe702fmNaa5axNM1C87nFpdb65LHEir9Yki
jowv3gkE6w/Rtb3IHcjZga8hrGwtALaMgn5B6ehoghTSlDQu3QnvOppJAWU3/sCl
oLtTfA66zv0ijSl4NmfYZiCeesKBdksla9MpiJw23nAKV0sPMpxqXGhitOuB8E1x
c+Dj6SazeTgguHn/DXDlF+2lpFIt/mTkbmPvovd2kAUjYp8buq8t7Qdxfd24MxiZ
gkWcXfvocakms3A1mme+XYoFK55zz5vvpL2S+CkgGwCFlGj3ST0zsPyhxXdORGAV
uyfP1qmql+U1z3wLSQn23erTuPwAIub6A/vpCpWwhqeNLij+t5bjuDkHfu9TUGeS
Uzth5Iwoz3Jp0YJMej+xcEYevRkbSf2eHydEXvWl/v1VMBrikv1jI4hDWGgcnJE4
zoZRB3DPYlzG2CeE8Kz73ZPCMspM4mbU+JGPDF7I6uxE1p86ySGftoaQnIYk7WI6
vExaiHCjCDS+6bXm6PEAVYtB8Vv+U78tl2f0S6C1bNecdGTSbv+OEA3Zw7+zcj0L
QVeH8E4xQ76z4CysK/CtMPaopzgNelEpxokTFcNmZz9w8vqnnT5uhhVJz08SHbDf
2EnkLG/3sVDrIcUuNY2Y
=gc4Y
-----END PGP SIGNATURE-----

--OROCMA9jn6tkzFBc--
