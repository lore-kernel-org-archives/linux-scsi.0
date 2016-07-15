From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: setup data needed in ISR before setting up the ISR
Date: Fri, 15 Jul 2016 15:00:22 -0400
Message-ID: <yq137nak9q1.fsf@sermon.lab.mkp.net>
References: <1467791510-5307-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34890 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbcGOTAd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2016 15:00:33 -0400
In-Reply-To: <1467791510-5307-1-git-send-email-jthumshirn@suse.de> (Johannes
	Thumshirn's message of "Wed, 6 Jul 2016 09:51:50 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, himanshu.madhani@qlogic.com

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

Johannes> qla2xxx first calls request_irq() and then does the setup of
Johannes> the queue entry data needed in the interrupt handlers in when
Johannes> using MSI-X.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
