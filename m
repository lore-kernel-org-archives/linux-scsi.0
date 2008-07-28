From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Mon, 28 Jul 2008 10:31:53 -0400
Message-ID: <yq1od4ikrl2.fsf@sermon.lab.mkp.net>
References: <20080619160342.GJ4392@parisc-linux.org>
	<20080625134705.GZ20851@kernel.dk> <4862552A.5010900@gmail.com>
	<48627184.9010609@panasas.com> <20080625165759.GC20851@kernel.dk>
	<20080625172015.GR4392@parisc-linux.org>
	<20080625172638.GE20851@kernel.dk>
	<yq1d4m575je.fsf@sermon.lab.mkp.net> <488DCB5A.9080105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:10173 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYG1Oci (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jul 2008 10:32:38 -0400
In-Reply-To: <488DCB5A.9080105@redhat.com> (Ric Wheeler's message of "Mon\, 28 Jul 2008 09\:36\:26 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rwheeler@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

>>>>> "Ric" == Ric Wheeler <rwheeler@redhat.com> writes:

Ric> One other thought - is there a way to give non-rotational devices
Ric> also some indication of latency? (FLASH is slower than enterprise
Ric> SSD is slower than DRAM ramdisk for example)?

The current SBC draft only distinguishes between rotating media
speeds.  There is only one classification for non-rotating media in
the block device characteristics VPD.

For a mechanical disk drive the rpm isn't a terrible gauge for
performance.  But for a solid state device I think it will be hard to
define a similar universal metric.

Ignoring SLC vs. MLC for a moment I think it's also safe to predict
that the enterprise drive of today will be the consumer drive of
tomorrow.

Maybe the ssd device could export the anticipated command response
time for a request that matches the Optimal Transfer Length field in
the block limits VPD?

-- 
Martin K. Petersen	Oracle Linux Engineering

