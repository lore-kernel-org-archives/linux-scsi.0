From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Mon, 06 Dec 2010 12:34:15 +0100
Message-ID: <87wrnnw2x4.fsf@nemi.mork.no>
References: <1290971729.2814.13.camel@larosa>
	<alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>
	<1291123886.2181.1347.camel@quux.techfak.uni-bielefeld.de>
	<alpine.LNX.2.00.1011301813460.9731@kai.makisara.local>
	<1291223211.2814.72.camel@larosa>
	<alpine.LNX.2.00.1012021823420.9213@kai.makisara.local>
	<alpine.LNX.2.00.1012060952570.7928@kai.makisara.local>
	<1291628171.2181.1366.camel@quux.techfak.uni-bielefeld.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:50912 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab0LFLuH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Dec 2010 06:50:07 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1PPZa0-0004XC-6O
	for linux-scsi@vger.kernel.org; Mon, 06 Dec 2010 12:50:04 +0100
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 06 Dec 2010 12:50:04 +0100
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 06 Dec 2010 12:50:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de> writes:

> I just tonight discovered that Debian's .config has
> CONFIG_FUSION_MAX_SGE=3D40. Right now I'm testing with the mptsas' dr=
ivers
> maximum of 128 and see if I can reproduce the failure under memory
> pressure again. Sorry for not catching this one earlier! After readin=
g
> the source, I had the assumption that it already was 128 ...

So did I... =20

I assume the difference is unintentional so I opened a Debian bug:
http://bugs.debian.org/606096


Bj=C3=B8rn

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
