From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: core: configure runtime pm before calling device_add in scsi_add_host_with_dma
Date: Thu, 25 Aug 2016 23:17:53 -0400
Message-ID: <yq1vayo9q1q.fsf@sermon.lab.mkp.net>
References: <792dc1a9-2280-d1a2-c088-cfdd28c67df3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32841 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755775AbcHZDT3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2016 23:19:29 -0400
In-Reply-To: <792dc1a9-2280-d1a2-c088-cfdd28c67df3@gmail.com> (Heiner
        Kallweit's message of "Wed, 3 Aug 2016 21:49:03 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Heiner" == Heiner Kallweit <hkallweit1@gmail.com> writes:

Heiner> Runtime PM should be configured already once we call
Heiner> device_add. See also the description in this mail thread
Heiner> https://lists.linuxfoundation.org/pipermail/linux-pm/2009-November/023198.html
Heiner> or the order of calls e.g. in usb_new_device.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
