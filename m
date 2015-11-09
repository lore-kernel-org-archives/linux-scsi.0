From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] scsi: Export SCSI Inquiry data to sysfs
Date: Mon, 09 Nov 2015 11:47:38 -0500
Message-ID: <yq1fv0fxgph.fsf@sermon.lab.mkp.net>
References: <1447063017-129232-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41636 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbbKIQrw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2015 11:47:52 -0500
In-Reply-To: <1447063017-129232-1-git-send-email-jthumshirn@suse.de> (Johannes
	Thumshirn's message of "Mon, 9 Nov 2015 10:56:57 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Bottomley <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

Johannes> Export the RAW SCSI Inquiry to sysfs as binfile. This way the
Johannes> data can be used by userland without the need to have and
Johannes> ioctl or use the sg_inq tool.

Applied.

-- 
Martin K. Petersen	Oracle Linux Engineering
