From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/4] [SCSI] Blacklist RSOC for Microsoft iSCSI target devices
Date: Thu, 04 Dec 2014 21:17:22 -0500
Message-ID: <yq1zjb2g7rh.fsf@sermon.lab.mkp.net>
References: <1417659492-2679-1-git-send-email-martin.petersen@oracle.com>
	<1417659492-2679-2-git-send-email-martin.petersen@oracle.com>
	<54810957.8080706@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43518 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaLECSt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2014 21:18:49 -0500
In-Reply-To: <54810957.8080706@cs.wisc.edu> (Mike Christie's message of "Thu,
	04 Dec 2014 19:24:39 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Mike" == Mike Christie <michaelc@cs.wisc.edu> writes:

Mike> In case other people test this patch, I wanted to warn people that
Mike> the MS iSCSI target does the same sequence (sends reject PDU then
Mike> drops the connection on us) for any command it does not
Mike> support. We end up seeing the same problem for other commands.

Ick. Have you pinged MS about this again recently? Doesn't sound like
we'd be the only ones tripping over something like this.

-- 
Martin K. Petersen	Oracle Linux Engineering
