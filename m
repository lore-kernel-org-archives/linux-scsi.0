From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 5/4] scsi: remove MSG_*_TAG defines
Date: Wed, 03 Dec 2014 21:31:53 -0500
Message-ID: <yq1h9xcjgbq.fsf@sermon.lab.mkp.net>
References: <1416839781-26988-1-git-send-email-hch@lst.de>
	<20141124150725.GA23165@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44531 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaLDCcU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2014 21:32:20 -0500
In-Reply-To: <20141124150725.GA23165@infradead.org> (Christoph Hellwig's
	message of "Mon, 24 Nov 2014 07:07:25 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Doug Ledford <dledford@redhat.com>

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> For SPI drivers use the message defintions from scsi.c, and
Christoph> for target drivers introduce a new TCM_*_TAG namespace.

s/defintions/definitions/

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
