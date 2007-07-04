From: Uwe Kiewel <mailing-list@kiewel-online.de>
Subject: Re: [SCSI] SD driver question
Date: Wed, 04 Jul 2007 18:56:37 +0200
Message-ID: <468BD145.5040100@kiewel-online.de>
References: <468BCE5C.6000707@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from post.kiewel-online.de ([85.214.49.162]:33059 "EHLO
	post.kiewel-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbXGDRIb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jul 2007 13:08:31 -0400
In-Reply-To: <468BCE5C.6000707@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Gabriel C schrieb:
> Hello,
> 
> Is there any reason why sd is printing the driver informations for each
> disk twice in dmesg ?
> 
> ...
> 
> sd 0:0:0:0: [sda] 35843670 512-byte hardware sectors (18352 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 9f 00 10 08
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports
> DPO and FUA
> sd 0:0:0:0: [sda] 35843670 512-byte hardware sectors (18352 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 9f 00 10 08
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports
> DPO and FUA
> sda: sda1
> sd 0:0:0:0: [sda] Attached SCSI disk
> sd 0:0:0:0: Attached scsi generic sg0 type 0

the samne here.
...
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HM080HC  AM10 PQ: 0 ANSI: 5
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
...

Please, can you tell the version of the kernel you use? I use:
[abkie@config-lappi ~]$ uname -r
2.6.21-1.3228.fc7
It is the current Fedora 7 kernel.


Regards,
Uwe

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGi9FFr6SFaBB7DLURAtb0AJ0YWiuBsEcOLChPvQcx6dOwvmPOxACfUsGT
3glIHhUVpqBOcizMaTcqU5M=
=xTfs
-----END PGP SIGNATURE-----
