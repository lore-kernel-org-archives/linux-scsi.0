From: Jens Schmalzing <jens.schmalzing@physik.uni-muenchen.de>
Subject: Re: CONFIG_SCSI_SYM53C8XX_IOMAPPED
Date: 16 Sep 2004 22:21:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <hhhdpyt167.fsf@theorie.physik.uni-muenchen.de>
References: <hhsm9iv8ws.fsf@alsvidh.mathematik.uni-muenchen.de>
	<20040916141323.GL642@parcelfarce.linux.theplanet.co.uk>
	<hh656el2dd.fsf@alsvidh.mathematik.uni-muenchen.de>
	<20040916153142.GM642@parcelfarce.linux.theplanet.co.uk>
	<hhllfat64h.fsf@theorie.physik.uni-muenchen.de>
	<20040916201432.GN642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alsvidh.mathematik.uni-muenchen.de ([129.187.111.42]:33408 "EHLO
	alsvidh.theorie.physik.uni-muenchen.de") by vger.kernel.org with ESMTP
	id S268237AbUIPUVj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Sep 2004 16:21:39 -0400
In-Reply-To: <20040916201432.GN642@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: debian-kernel@lists.debian.org, linux-scsi@vger.kernel.org

Hi,

Matthew Wilcox writes:

> Urm.  I don't understand.  You said that you encountered the problem
> in a Thinkpad 860, but bug 271852 refers to a powerpc-specific proble=
m.

That's exactly what the Thinkpad 8xx series are - RS/6000 systems with
PowerPC 603e processors.  See:

korgan:~# cat /proc/cpuinfo=20
processor       : 0
cpu             : 603ev
clock           : 166MHz
revision        : 2.0 (pvr 0007 0200)
bogomips        : 110.33
machine         : PReP IBM Thinkpad 850/860
upgrade cpu     : not present
scsi fuse       : ok
simms           : 0:32MiB=20
l2 cache        : 256KiB look-aside direct-mapped write-back
60x bus         : 66MHz
pci bus         : 33MHz

Regards, Jens.

--=20
J'qbpbe, le m'en fquz pe j'qbpbe!
Le veux aimeb et mqubib panz je p=E9zqbpbe je djuz tqtaj!
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
