From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/4] fix dma_unmap_sg() parameter in some scsi drivers
Date: Mon, 22 Jan 2018 19:45:23 -0500
Message-ID: <yq1h8rdiesc.fsf@oracle.com>
References: <1515033405-37477-1-git-send-email-chenxiang66@hisilicon.com>
        <c7f7ba3f-9a0f-e251-27f6-0ad582d8a88e@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48508 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751253AbeAWAqF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2018 19:46:05 -0500
In-Reply-To: <c7f7ba3f-9a0f-e251-27f6-0ad582d8a88e@hisilicon.com> (chenxiang's
        message of "Mon, 22 Jan 2018 15:50:28 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "chenxiang (M)" <chenxiang66@hisilicon.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, john.garry@huawei.com, linux-scsi@vger.kernel.org, linuxarm@huawei.com, bryantly@linux.vnet.ibm.com, mikecyr@linux.vnet.ibm.com, artur.paszkiewicz@intel.com, dan.j.williams@intel.com, yuxiangl@marvell.com, jgarzik@pobox.com, jack_wang@usish.com, lindar_liu@usish.com, xjtuwjp@gmail.com


Chenxiang,

> does anyone notice and review this issue?

It's a pretty crappy interface that has to have explanatory "notes"
throughout the documentation saying "Don't use this the obvious way, do
this instead". As evidenced by 5 drivers messing it up.

Your change looks good to me. But before I apply I'd like somebody from
the IBM camp to verify that fixing this doesn't unintentionally break
stuff on power.

-- 
Martin K. Petersen	Oracle Linux Engineering
