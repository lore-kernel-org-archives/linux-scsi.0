From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/4] scsi: remove scsi_set_tag_type
Date: Wed, 03 Dec 2014 21:29:43 -0500
Message-ID: <yq1lhmojgfc.fsf@sermon.lab.mkp.net>
References: <1416839781-26988-1-git-send-email-hch@lst.de>
	<1416839781-26988-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43854 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaLDC3u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2014 21:29:50 -0500
In-Reply-To: <1416839781-26988-5-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Mon, 24 Nov 2014 15:36:21 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Doug Ledford <dledford@redhat.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> There is no benefit over just setting sdev->simple_tags
Christoph> directly.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
