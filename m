From: Heiko Nardmann <h.nardmann@secunet.de>
Subject: Q: SCSI driver error messages - 2.4.18 kernel
Date: Wed, 18 Sep 2002 09:27:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209180928.06407.h.nardmann@secunet.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailscan-1.tuev-mitte.de (mailscan-1.tuev-mitte.de [10.0.142.44])
	by mailgate.cubis.de (Switch-2.1.1/Switch-2.1.1) with SMTP id U8I70SAU28718
	for <linux-scsi@vger.kernel.org>; Wed, 18 Sep 2002 09:28:10 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi!

Maybe I am a bit off topic but I sometimes get error messages like the 
following in my /var/adm/messages file. Since I do not really know how to 
interpret them I wonder what to do. Does this mean that my drive dies slowly 
or is it possible that is due to some termination problem?

Sep 18 09:10:57 snsrv053 kernel: scsi0: ERROR on channel 0, id 0, lun 0, CDB: 
Read (10) 00 00 1b e7 a6 00 00 d0 00
Sep 18 09:10:57 snsrv053 kernel: Info fld=0x1be83a, Current sd08:06: sense key 
Medium Error
Sep 18 09:10:57 snsrv053 kernel: Additional sense indicates Unrecovered read 
error - recommend reassignment
Sep 18 09:10:57 snsrv053 kernel:  I/O error: dev 08:06, sector 432154
Sep 18 09:10:58 snsrv053 kernel: scsi0: ERROR on channel 0, id 0, lun 0, CDB: 
Read (10) 00 00 1b e8 3a 00 00 02 00
Sep 18 09:10:58 snsrv053 kernel: Info fld=0x1be83a, Current sd08:06: sense key 
Medium Error
Sep 18 09:10:58 snsrv053 kernel: Additional sense indicates Unrecovered read 
error - recommend reassignment
Sep 18 09:10:58 snsrv053 kernel:  I/O error: dev 08:06, sector 432154

Any idea?

- -- 
Heiko Nardmann (Dipl.-Ing.), h.nardmann@secunet.de, Software Development
secunet Security Networks AG - Sicherheit in Netzwerken (www.secunet.de),
Weidenauer Str. 223-225, D-57076 Siegen
Tel. : +49 271 48950-13, Fax  : +49 271 48950-50
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iEYEARECAAYFAj2IKwAACgkQpm53PRScYyienQCePmJ9NQDsj4AP6A9ElLIDxyr4
K5wAoM/Y2xJgHZokYytVpOs5EUU0lJUe
=Kxtt
-----END PGP SIGNATURE-----

