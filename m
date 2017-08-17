From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Revert "scsi-mq: Always unprepare before requeuing a request"
Date: Wed, 16 Aug 2017 22:51:00 -0400
Message-ID: <yq1tw16nbzf.fsf@oracle.com>
References: <20170816174324.29276-1-bart.vanassche@wdc.com>
        <yq1fucrqchu.fsf@oracle.com>
        <a757a93a-0052-e22f-b035-b8cc27256dc5@wdc.com>
        <3401ef29-7450-eb15-9dd1-2f021354286d@wdc.com>
        <yq18tijow0o.fsf@oracle.com> <1502933351.14158.3.camel@wdc.com>
        <yq1a82znec9.fsf@oracle.com> <1502937699.2763.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1502937699.2763.1.camel@wdc.com> (Bart Van Assche's message of
        "Thu, 17 Aug 2017 02:41:41 +0000")
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, Damien Le Moal <Damien.LeMoal@wdc.com>, "hch@lst.de" <hch@lst.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "abdhalee@linux.vnet.ibm.com" <abdhalee@linux.vnet.ibm.com>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>
List-Id: linux-scsi@vger.kernel.org


Bart,

> When I checked earlier today the ipr patch was not yet in linux-next

That's weird. They were both committed two weeks ago.

They appear to be in there now, though:

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/log/drivers/scsi?ofs=50

-- 
Martin K. Petersen	Oracle Linux Engineering
