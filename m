From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined reference to `request_firmware'
Date: Fri, 16 May 2008 22:30:40 +0200
Message-ID: <200805162230.41350.rjw@sisk.pl>
References: <200805161906.19321.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:48593 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390AbYEPUah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 May 2008 16:30:37 -0400
In-Reply-To: <200805161906.19321.toralf.foerster@gmx.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Friday, 16 of May 2008, Toralf F=F6rster wrote:
> Hello,
>=20
> the build (.config attached) failed, make ends with :
> ...
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      vmlinux
> drivers/built-in.o: In function `sas_request_addr':
> (.text+0x33bab): undefined reference to `request_firmware'
> drivers/built-in.o: In function `sas_request_addr':
> (.text+0x33c3f): undefined reference to `release_firmware'
> make: *** [vmlinux] Error 1
>=20
> The build was made with :
> $>make randconfig; make clean; make

Is it the same as http://bugzilla.kernel.org/show_bug.cgi?id=3D10707 ?

Rafael
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
