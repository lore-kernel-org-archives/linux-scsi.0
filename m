From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: status of block-integrity
Date: Thu, 09 Jan 2014 20:49:53 -0500
Message-ID: <yq1vbxssj0e.fsf@sermon.lab.mkp.net>
References: <20131222192128.GA28532@infradead.org> <52C6D0DB.1050906@suse.de>
	<yq1wqigzvc1.fsf@sermon.lab.mkp.net>
	<20140107013646.GB10297@birch.djwong.org> <52CBAA1B.7000509@suse.de>
	<yq1a9f7wjqr.fsf@sermon.lab.mkp.net> <52CCFADB.6080909@suse.de>
	<yq1lhyqv6ns.fsf@sermon.lab.mkp.net> <52CE85C6.8000405@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18439 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaAJBu3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jan 2014 20:50:29 -0500
In-Reply-To: <52CE85C6.8000405@suse.de> (Hannes Reinecke's message of "Thu, 09
	Jan 2014 12:19:34 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, chuck.lever@oracle.com, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Doug Gilbert <dgilbert@interlog.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> With LID1/XCopy you have the ambiguity on where to actually send
Hannes> the command to; the spec is silent in this area.

Yeah, right now it's a coin toss.

However, thanks to VAAI most arrays support LID1. I'm trying to leverage
that. Doesn't in any way preclude LID4 being supported as well.

Hannes> As said, Doug and me are working on putting this into sg3_utils,
Hannes> then we'll have a better idea on the actual workings.

Cool! That'll save me some headaches when we start seeing LID4 devices.

-- 
Martin K. Petersen	Oracle Linux Engineering
