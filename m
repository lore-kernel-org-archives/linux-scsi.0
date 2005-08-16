From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: [PATCH 2.6.13-rc6] remove dead reset function from cpqfcTS driver
Date: Tue, 16 Aug 2005 10:49:27 -0400
Message-ID: <yq14q9qdjig.fsf@wilson.lab.mkp.net>
References: <200508051202.07091@bilbo.math.uni-mannheim.de>
	<200508161111.08070@bilbo.math.uni-mannheim.de>
	<20050816091758.GA21378@infradead.org>
	<200508161137.37749@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vanessarodrigues.com ([192.139.46.150]:14269 "EHLO
	jaguar.mkp.net") by vger.kernel.org with ESMTP id S965254AbVHPOtn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Aug 2005 10:49:43 -0400
In-Reply-To: <200508161137.37749@bilbo.math.uni-mannheim.de> (Rolf Eike Beer's message of "Tue, 16 Aug 2005 11:37:30 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, Bolke de Bruin <bdbruin@aub.nl>

>>>>> "Rolf" == Rolf Eike Beer <eike-kernel@sf-tec.de> writes:

Hey Rolf!

Rolf> There was a request on lkml last week for a working version of
Rolf> this driver. For the moment I try to clean this up a bit before
Rolf> doing some real work. I found 4 major things that should be
Rolf> done, for half of them I have patches in a proof-of-concept
Rolf> state.

As Christoph said I'm working on a driver for the TachLite TL/TS/XL2
chips.

Initially I just wanted to add support for the integrated PHY on XL2
so we could support those cards on PA-RISC.  But when I started
looking at the driver I came to the conclusion that it was just too
ugly to live.  Architecturally, the overall design of cpqfc just
doesn't fit in well with Linux.  So I'm rewriting it from scratch -
but that obviously takes a while.

I think it's cool that you want to hack on cpqfcTS.  But be aware that
it's not just a matter of running lindent and making it compile in
2.6.late.  And without hardware it's going to be hard.  Fibre channel
is very finicky.

If you manage to get your hands on hardware (cards - avoid Tachyon
5000 series. TachLite 5100, 5166 or 5200 is what you want, disk array,
hub/switch, GBICs, etc.) I wouldn't mind some help...

-- 
Martin K. Petersen      http://mkp.net/
