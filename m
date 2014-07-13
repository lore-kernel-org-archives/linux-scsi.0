From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 06/10] sd: don't use scsi_setup_blk_pc_cmnd for discard requests
Date: Sun, 13 Jul 2014 11:03:43 -0400
Message-ID: <yq1sim5xpv4.fsf@sermon.lab.mkp.net>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
	<1404048881-19526-7-git-send-email-hch@lst.de>
	<yq14myl1g3q.fsf@sermon.lab.mkp.net> <53C29D45.8000301@interlog.com>
	<20140713145622.GA1831@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48217 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaGMPDx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jul 2014 11:03:53 -0400
In-Reply-To: <20140713145622.GA1831@lst.de> (Christoph Hellwig's message of
	"Sun, 13 Jul 2014 16:56:22 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> On Sun, Jul 13, 2014 at 10:52:53AM -0400, Douglas Gilbert wrote:
>> To make things clearer when referring to the WRITE SAME command I
>> would suggest "WRITE SAME(unmap)" for the case when its UNMAP field
>> is 1 (as I assume it is in this case).

Christoph> Actually it could be WRITE SAME (10) with or without unmap,
Christoph> or WRITE SAME (16) with unmap.  So just leaving it without
Christoph> qualifier here seems to be least confusing.

Yeah. I tried to come up with a way to be accurate but simpler seemed
clearer in this case.

-- 
Martin K. Petersen	Oracle Linux Engineering
