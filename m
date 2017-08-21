From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd_zbc: Disable zoned block devices with scsi-mq
Date: Mon, 21 Aug 2017 16:31:32 -0400
Message-ID: <yq1d17oek7v.fsf@oracle.com>
References: <20170817024550.9845-1-damien.lemoal@wdc.com>
        <20170817075916.GA28379@infradead.org>
        <2b78a557-d573-9ba1-0068-56417042ffc8@wdc.com>
        <1502982108.2615.1.camel@wdc.com> <20170821153351.GB20205@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39870 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753747AbdHUUcY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2017 16:32:24 -0400
In-Reply-To: <20170821153351.GB20205@lst.de> (hch@lst.de's message of "Mon, 21
        Aug 2017 17:33:51 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@infradead.org" <hch@infradead.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>


Christoph,

> But it seems like we need to refne the always unprepare patch first,
> to make sure we only release resources, but don't clear the
> scmd->retries field.  The NVMe driver already works that way, so
> we have an example to follow.

Agree!

-- 
Martin K. Petersen	Oracle Linux Engineering
