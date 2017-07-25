From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] SCSI: remove DRIVER_ATTR() usage
Date: Mon, 24 Jul 2017 21:54:21 -0400
Message-ID: <yq1379l2sdu.fsf@oracle.com>
References: <20170719125006.GA17776@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24830 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751869AbdGYByg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2017 21:54:36 -0400
In-Reply-To: <20170719125006.GA17776@kroah.com> (Greg KH's message of "Wed, 19
        Jul 2017 14:50:06 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Willem Riede <osst@riede.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Greg,

> It's better to use the DRIVER_ATTR_RW() and DRIVER_ATTR_RO() macros to
> explicitly show that this is a read/write or read/only sysfs file.  So
> convert the remaining SCSI drivers that use the old style to use the
> newer macros.

Applied to 4.14/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
