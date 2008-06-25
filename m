From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Wed, 25 Jun 2008 14:06:45 -0400
Message-ID: <yq1d4m575je.fsf@sermon.lab.mkp.net>
References: <20080619160342.GJ4392@parisc-linux.org>
	<20080625134705.GZ20851@kernel.dk> <4862552A.5010900@gmail.com>
	<48627184.9010609@panasas.com> <20080625165759.GC20851@kernel.dk>
	<20080625172015.GR4392@parisc-linux.org>
	<20080625172638.GE20851@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:33909 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYFYSHK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2008 14:07:10 -0400
In-Reply-To: <20080625172638.GE20851@kernel.dk> (Jens Axboe's message of "Wed\, 25 Jun 2008 19\:26\:39 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Boaz Harrosh <bharrosh@panasas.com>, Ric Wheeler <ricwheeler@gmail.com>, linux-scsi@vger.kernel.org

>>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:

Jens> Uhm, but it IS "a blatant layering violation", it's doing things
Jens> from the wrong side up :-)

I also disagree with mucking with the elevator directly in sd.c.

The whole point of my I/O hints work is to expose the I/O topology in
a generic fashion so that upper layers can take advantage of them.

I'll post a new batch of those patches shortly...

-- 
Martin K. Petersen	Oracle Linux Engineering

