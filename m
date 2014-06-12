From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 13/14] lib: Add T10 Protection Information functions
Date: Wed, 11 Jun 2014 22:23:50 -0400
Message-ID: <yq1zjhiq30p.fsf@sermon.lab.mkp.net>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
	<1401334128-15499-14-git-send-email-martin.petersen@oracle.com>
	<20140611165630.GH9511@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17986 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaFLCYU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 22:24:20 -0400
In-Reply-To: <20140611165630.GH9511@infradead.org> (Christoph Hellwig's
	message of "Wed, 11 Jun 2014 09:56:30 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

>> static struct blk_integrity dif_type1_integrity_crc = {

Christoph> Shouldn't the whole profile defintions move to the generic
Christoph> code as well? 

Yeah, good idea.

Christoph> Maybe the code also should live in block/ and not lib/.

Fine by me. Jens?

-- 
Martin K. Petersen	Oracle Linux Engineering
