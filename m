From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 0/6] PS3 Storage Drivers for 2.6.23, take 3
Date: Thu, 21 Jun 2007 16:14:19 +0200
Message-ID: <20070621141419.480922000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0477849999=="
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--===============0477849999==

	Hi,

This is the third submission of the new PS3 storage drivers:
  [1] ps3: Preallocate bootmem memory for the PS3 FLASH ROM storage driver
  [2] ps3: Storage Driver Core
  [3] ps3: Storage device registration routines.
  [4] ps3: Disk Storage Driver
  [5] ps3: BD/DVD/CD-ROM Storage Driver
  [6] ps3: FLASH ROM Storage Driver

They are based on:
  - the current Linux kernel source tree,
  - plus the PS3 patches already submitted by Geoff Levand on linuxppc-dev,
  - plus the shost_priv() patch in scsi-misc.

All issues raised during the previous review rounds should be fixed.

If there are no more comments, please apply for 2.6.23.  Since they depend on
other PS3 work, I think it's most logical to let Paul integrate them.

Thanks in advance!

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619


--===============0477849999==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linuxppc-dev mailing list
Linuxppc-dev@ozlabs.org
https://ozlabs.org/mailman/listinfo/linuxppc-dev
--===============0477849999==--
