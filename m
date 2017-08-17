From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Revert "scsi-mq: Always unprepare before requeuing a request"
Date: Thu, 17 Aug 2017 13:48:59 -0400
Message-ID: <yq1bmnekruc.fsf@oracle.com>
References: <20170816174324.29276-1-bart.vanassche@wdc.com>
        <yq1fucrqchu.fsf@oracle.com>
        <a757a93a-0052-e22f-b035-b8cc27256dc5@wdc.com>
        <3401ef29-7450-eb15-9dd1-2f021354286d@wdc.com>
        <yq18tijow0o.fsf@oracle.com> <1502933351.14158.3.camel@wdc.com>
        <yq1a82znec9.fsf@oracle.com> <1502937699.2763.1.camel@wdc.com>
        <yq1tw16nbzf.fsf@oracle.com> <1502983764.2615.3.camel@wdc.com>
        <yq14lt6m9c0.fsf@oracle.com>
        <ff56b05f-0493-5d28-82d1-d9626b0e25c1@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <ff56b05f-0493-5d28-82d1-d9626b0e25c1@linux.vnet.ibm.com> (Brian
        King's message of "Thu, 17 Aug 2017 12:40:41 -0500")
Sender: stable-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, Damien Le Moal <Damien.LeMoal@wdc.com>, "hch@lst.de" <hch@lst.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "abdhalee@linux.vnet.ibm.com" <abdhalee@linux.vnet.ibm.com>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>
List-Id: linux-scsi@vger.kernel.org


Brian,

> They are separate issues. The ipr fix that is now upstream is for a
> locking issue in ipr. The boot hang issue is a separate issue. I can
> reproduce the boot hang on a system with my ipr patch. I've confirmed
> it goes away when reverting Bart's patch but it makes no sense as of
> yet as to why.

OK. Thanks for the update. Let us know if there is something we can do
to help.

-- 
Martin K. Petersen	Oracle Linux Engineering
