From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/4] scsi: remove ->change_queue_type method
Date: Wed, 03 Dec 2014 21:27:26 -0500
Message-ID: <yq1y4qojgj5.fsf@sermon.lab.mkp.net>
References: <1416839781-26988-1-git-send-email-hch@lst.de>
	<1416839781-26988-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43713 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbaLDC1f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2014 21:27:35 -0500
In-Reply-To: <1416839781-26988-2-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Mon, 24 Nov 2014 15:36:18 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Doug Ledford <dledford@redhat.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Since we got rid of ordered tag support in 2010 the prime use
Christoph> case of switching on and off ordered tags has been obsolete.
Christoph> The other function of enabling/dsiabling tagging entirely has
Christoph> only been correctly implemented by the 53c700 driver and
Christoph> isn't generally useful.

s/dsiabling/disabling/

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
