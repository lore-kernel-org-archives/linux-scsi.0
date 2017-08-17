From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Revert "scsi-mq: Always unprepare before requeuing a request"
Date: Wed, 16 Aug 2017 22:00:06 -0400
Message-ID: <yq1a82znec9.fsf@oracle.com>
References: <20170816174324.29276-1-bart.vanassche@wdc.com>
        <yq1fucrqchu.fsf@oracle.com>
        <a757a93a-0052-e22f-b035-b8cc27256dc5@wdc.com>
        <3401ef29-7450-eb15-9dd1-2f021354286d@wdc.com>
        <yq18tijow0o.fsf@oracle.com> <1502933351.14158.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37645 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbdHQCA1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2017 22:00:27 -0400
In-Reply-To: <1502933351.14158.3.camel@wdc.com> (Bart Van Assche's message of
        "Thu, 17 Aug 2017 01:29:13 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "abdhalee@linux.vnet.ibm.com" <abdhalee@linux.vnet.ibm.com>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>


Bart,

> I'm 99% sure there is nothing wrong with my patch but that my patch
> uncovered a bug in the ipr driver (drivers/scsi/ipr). See also
> "WARNING: CPU: 15 PID: 0 at block/blk-mq.c:1111
> __blk_mq_run_hw_queue+0x1d8/0x1f0F"
> (https://marc.info/?l=linux-block&m=150290686719644).

But I already have the ipr patch queued. What am I missing?

-- 
Martin K. Petersen	Oracle Linux Engineering
