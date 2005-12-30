From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: Booting from or using a Compaq RA4100 Array
Date: Fri, 30 Dec 2005 17:18:12 -0500
Message-ID: <yq1oe2y44bf.fsf@wilson.lab.mkp.net>
References: <1135801791.9541.12.camel@gateway.markschaefer.org>
	<200512290845.17192@bilbo.math.uni-mannheim.de>
	<62187.24.3.12.198.1135893081.squirrel@www.markschaefer.org>
	<200512292302.50743@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vanessarodrigues.com ([192.139.46.150]:35771 "EHLO
	jaguar.mkp.net") by vger.kernel.org with ESMTP id S1750929AbVL3WSR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Dec 2005 17:18:17 -0500
In-Reply-To: <200512292302.50743@bilbo.math.uni-mannheim.de> (Rolf Eike Beer's message of "Thu, 29 Dec 2005 23:02:45 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: mark@markschaefer.org, linux-scsi@vger.kernel.org

>>>>> "Eike" == Rolf Eike Beer <eike-kernel@sf-tec.de> writes:

[LUN mangling]

Eike> I've looked around a bit in the LUN code some month ago as I was
Eike> trying to get this to a state where it was sort of working. This
Eike> code is as horrible as the rest of this driver, so I didn't
Eike> really got the point what of this strange stuff is really needed
Eike> and what was just caused by code monkeys on drugs.

Yeah, I talked to James about this a while back and he said the only
acceptable approach for dealing with deprecated TYPE_RAID devices
would be to write an upper level driver.  If you'd be interested in
working on that, that'd be awesome.


Eike> Now the driver is buried and all the people with such hardware
Eike> come out of their holes. Fascinating :)) I was thinking about a
Eike> list related only to these things and/or writing a FAQ for
Eike> this. What do the other people around think about this? MKP?

Sure.  I'll try to conjure up a web page about cpqfcTS, RA4x00, and
the current state of the tachyon nation.

-- 
Martin K. Petersen      http://mkp.net/
