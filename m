From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/4] scsi: remove scsi_get_tag_type
Date: Wed, 03 Dec 2014 21:28:54 -0500
Message-ID: <yq1ppc0jggp.fsf@sermon.lab.mkp.net>
References: <1416839781-26988-1-git-send-email-hch@lst.de>
	<1416839781-26988-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44213 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaLDC3B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2014 21:29:01 -0500
In-Reply-To: <1416839781-26988-4-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Mon, 24 Nov 2014 15:36:20 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Doug Ledford <dledford@redhat.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Both remaining users are better of just checking
Christoph> sdev->simple_tags directly.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
