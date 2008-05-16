From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined
 reference to `request_firmware'
Date: Fri, 16 May 2008 13:52:25 -0700
Message-ID: <20080516135225.e6f8b2c7.randy.dunlap@oracle.com>
References: <200805161906.19321.toralf.foerster@gmx.de>
	<200805162230.41350.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:39351 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbYEPUxa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 May 2008 16:53:30 -0400
In-Reply-To: <200805162230.41350.rjw@sisk.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 16 May 2008 22:30:40 +0200 Rafael J. Wysocki wrote:

> On Friday, 16 of May 2008, Toralf F=F6rster wrote:
> > Hello,
> >=20
> > the build (.config attached) failed, make ends with :
> > ...
> >   UPD     include/linux/compile.h
> >   CC      init/version.o
> >   LD      init/built-in.o
> >   LD      vmlinux
> > drivers/built-in.o: In function `sas_request_addr':
> > (.text+0x33bab): undefined reference to `request_firmware'
> > drivers/built-in.o: In function `sas_request_addr':
> > (.text+0x33c3f): undefined reference to `release_firmware'
> > make: *** [vmlinux] Error 1
> >=20
> > The build was made with :
> > $>make randconfig; make clean; make
>=20
> Is it the same as http://bugzilla.kernel.org/show_bug.cgi?id=3D10707 =
?

It's in a different driver.

---
~Randy
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
