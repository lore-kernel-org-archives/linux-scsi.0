From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: add support for TCG OPAL self encrypting disks
Date: Tue, 27 Jun 2017 21:02:17 -0400
Message-ID: <yq1wp7wzzza.fsf@oracle.com>
References: <20170619122646.32666-1-hch@lst.de>
        <20170619122646.32666-2-hch@lst.de> <20170626111047.GA16273@lst.de>
        <yq1tw327l8w.fsf@oracle.com> <20170626205220.GA27428@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20170626205220.GA27428@htj.duckdns.org> (Tejun Heo's message of
        "Mon, 26 Jun 2017 16:52:20 -0400")
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Scott Bauer <scott.bauer@intel.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Tejun,

>> Looks good to me. I'll queue it up for 4.13 as soon as Linus has pulled
>> in the ata bits.
>
> I can route it through libata tree w/ your ack if that's more convenient.

I don't think it will cause any headaches. I'm just a bit cautious since
I already have a ton of conflicts in linux-next for this merge window.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
