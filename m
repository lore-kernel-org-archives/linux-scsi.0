From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hpsa: remove unneeded void pointer cast
Date: Fri, 14 Oct 2016 16:23:16 -0400
Message-ID: <yq1wphak7d7.fsf@sermon.lab.mkp.net>
References: <1476375008-10034-1-git-send-email-javier@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39854 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932817AbcJNUXx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2016 16:23:53 -0400
In-Reply-To: <1476375008-10034-1-git-send-email-javier@osg.samsung.com>
        (Javier Martinez Canillas's message of "Thu, 13 Oct 2016 13:10:08
        -0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, esc.storagedev@microsemi.com, Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Javier" == Javier Martinez Canillas <javier@osg.samsung.com> writes:

Javier> It's not necessary to cast the result of kmalloc, since void
Javier> pointers are promoted to any other type. This also fixes
Javier> following coccinelle warning:

Javier> casting value returned by memory allocation function to
Javier> (BIG_IOCTL_Command_struct *) is useless.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
