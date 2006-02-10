From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: cpqfc
Date: Fri, 10 Feb 2006 14:04:14 -0500
Message-ID: <yq1u0b79gsx.fsf@wilson.lab.mkp.net>
References: <Pine.GSO.4.64.0602061840520.24390@filebunker.xip.at>
	<200602061923.31944@bilbo.math.uni-mannheim.de>
	<Pine.GSO.4.64.0602061921160.94@filebunker.xip.at>
	<200602070855.34920@bilbo.math.uni-mannheim.de>
	<Pine.GSO.4.64.0602071058530.26505@filebunker.xip.at>
	<Pine.GSO.4.64.0602101220450.2743@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vanessarodrigues.com ([192.139.46.150]:61858 "EHLO
	jaguar.mkp.net") by vger.kernel.org with ESMTP id S1750872AbWBJTES
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 14:04:18 -0500
In-Reply-To: <Pine.GSO.4.64.0602101220450.2743@filebunker.xip.at> (Ingo Flaschberger's message of "Fri, 10 Feb 2006 12:26:27 +0100 (CET)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Flaschberger <if@xip.at>
Cc: linux-scsi@vger.kernel.org

>>>>> "Ingo" == Ingo Flaschberger <if@xip.at> writes:

Ingo> I have not received any answer regarding implementation of a new
Ingo> driver for the cpqfc adapter.

I've been away for a couple of days and I'm still catching up on mail.

It is correct that I've been working on a generic tachyon driver for a
while.  It is, however, still at the "poke this register and see what
happens" stage.  As soon as I get the driver to a point where it makes
sense to have other people pick at it I'll submit it here.


Ingo> In one week I will start to port the old 2.4 driver to 2.6; with
Ingo> all its "not nice" code, because it works!

No it doesn't.  It has data corruption issues.

If you really want to help there's still the issue of RA4100 and other
(if there are any?) TYPE_RAID devices not working.  That should be a
really quick hack and would make a lot of people happy.

Check the archives for info...

-- 
Martin K. Petersen      http://mkp.net/
