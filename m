From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Revert "scsi-mq: Always unprepare before requeuing a request"
Date: Thu, 17 Aug 2017 12:45:51 -0400
Message-ID: <yq14lt6m9c0.fsf@oracle.com>
References: <20170816174324.29276-1-bart.vanassche@wdc.com>
        <yq1fucrqchu.fsf@oracle.com>
        <a757a93a-0052-e22f-b035-b8cc27256dc5@wdc.com>
        <3401ef29-7450-eb15-9dd1-2f021354286d@wdc.com>
        <yq18tijow0o.fsf@oracle.com> <1502933351.14158.3.camel@wdc.com>
        <yq1a82znec9.fsf@oracle.com> <1502937699.2763.1.camel@wdc.com>
        <yq1tw16nbzf.fsf@oracle.com> <1502983764.2615.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49748 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752335AbdHQQrK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2017 12:47:10 -0400
In-Reply-To: <1502983764.2615.3.camel@wdc.com> (Bart Van Assche's message of
        "Thu, 17 Aug 2017 15:29:26 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, Damien Le Moal <Damien.LeMoal@wdc.com>, "hch@lst.de" <hch@lst.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "abdhalee@linux.vnet.ibm.com" <abdhalee@linux.vnet.ibm.com>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>


Bart,

> I think this means that the ipr fix went upstream before it ended up in
> linux-next.

OK.

Brian: Please make sure you test with your ipr change in place as well
as Bart's patch. And then report back.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
