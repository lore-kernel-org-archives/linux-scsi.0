From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] lpfc: call lpfc_sli_validate_fcp_iocb() with the hbalock held
Date: Wed, 20 Jul 2016 19:46:57 -0400
Message-ID: <yq18twvg9e6.fsf@sermon.lab.mkp.net>
References: <1468850763-72179-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17150 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbcGTXvZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2016 19:51:25 -0400
In-Reply-To: <1468850763-72179-1-git-send-email-jthumshirn@suse.de> (Johannes
	Thumshirn's message of "Mon, 18 Jul 2016 16:06:03 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

Johannes> Call lpfc_sli_validate_fcp_iocb() with the hbalock held, as
Johannes> the pointer to iocbq is not guaranteed to still be valid after
Johannes> looking it up.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
