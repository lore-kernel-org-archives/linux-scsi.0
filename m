From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: setup data needed in ISR before setting up the ISR
Date: Thu, 14 Jul 2016 00:28:37 -0400
Message-ID: <yq14m7slu6i.fsf@sermon.lab.mkp.net>
References: <1467791510-5307-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45380 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbcGNEhR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2016 00:37:17 -0400
In-Reply-To: <1467791510-5307-1-git-send-email-jthumshirn@suse.de> (Johannes
	Thumshirn's message of "Wed, 6 Jul 2016 09:51:50 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

Johannes> qla2xxx first calls request_irq() and then does the setup of
Johannes> the queue entry data needed in the interrupt handlers in when
Johannes> using MSI-X. This could lead to a NULL pointer dereference
Johannes> when an IRQ fires between the request_irq() call and the
Johannes> assignment of the qentry data structure to the
rsp-> msix field. A possible case for such a race would be in the kdump
Johannes> case when the HBA's IRQs are still enabled but the driver is
Johannes> undergoing a new initialisation and thus is not aware of
Johannes> already activated IRQs in the HBA.

Qlogic folks: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
