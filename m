From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 0/3] debloat aic7xxx and aic79xx drivers
Date: Fri, 31 Aug 2007 12:27:22 -0400
Message-ID: <31870.1188577642@turing-police.cc.vt.edu>
References: <200708311613.59666.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1188577642_3280P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761247AbXHaQ2E@vger.kernel.org>
In-Reply-To: Your message of "Fri, 31 Aug 2007 16:13:59 BST."
             <200708311613.59666.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Hannes Reinecke <hare@suse.de>, Jan Engelhardt <jengelh@computergmbh.de>, Matthew Wilcox <matthew@wil.cx>, Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--==_Exmh_1188577642_3280P
Content-Type: text/plain; charset=us-ascii

On Fri, 31 Aug 2007 16:13:59 BST, Denys Vlasenko said:
>
>    text    data     bss     dec     hex filename
>  261433   50018    1172  312623   4c52f linux-2.6.23-rc1.org.t/drivers/scsi/aic7xxx/built-in.o
>  199654   50018    1172  250844   3d3dc linux-2.6.23-rc1.aic.t/drivers/scsi/aic7xxx/built-in.o
>  184014   21314    1172  206500   326a4 linux-2.6.23-rc1.aic1.t/drivers/scsi/aic7xxx/built-in.o
>  202378    2850    1172  206400   32640 linux-2.6.23-rc1.aic2.t/drivers/scsi/aic7xxx/built-in.o
> 
> 1-debloat.patch    deinlines a lot of functions
> 2-addstatic.patch  adds statics, #ifdefs out huge amount of unused code, adds consts
> 3-addconst.patch   adds more consts

Yowza.  Looking at aic1->aic2, it looks like 20K became 'const', and only
3K *wasn't* 'const'?  

--==_Exmh_1188577642_3280P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG2EFqcC3lWbTT17ARAh+AAKDX7YTjFTX/ZrQYyx4bUUOimywHoQCgi6Ar
t9E19PFY3NuWrY7bBTvtDno=
=BROT
-----END PGP SIGNATURE-----

--==_Exmh_1188577642_3280P--
