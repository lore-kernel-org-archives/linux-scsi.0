From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 6/6] scsi: return EAGAIN when resetting a device under EH
Date: Wed, 05 Nov 2014 09:33:07 -0500
Message-ID: <yq1tx2dd8f0.fsf@sermon.lab.mkp.net>
References: <1414661229-15199-1-git-send-email-hch@lst.de>
	<1414661229-15199-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23032 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaKEOdO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2014 09:33:14 -0500
In-Reply-To: <1414661229-15199-7-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Thu, 30 Oct 2014 10:27:09 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> - return -ENODEV;
Christoph> + return -EAGAIN;

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
