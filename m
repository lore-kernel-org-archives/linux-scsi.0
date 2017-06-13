From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 6/6] sd: add support for TCG OPAL self encrypting disks
Date: Tue, 13 Jun 2017 11:19:20 -0400
Message-ID: <yq17f0fykxz.fsf@oracle.com>
References: <20170604124225.27032-1-hch@lst.de>
        <20170604124225.27032-7-hch@lst.de> <yq1lgp6djr3.fsf@oracle.com>
        <20170606095802.GA20590@lst.de> <20170613064018.GA31330@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170613064018.GA31330@lst.de> (Christoph Hellwig's message of
        "Tue, 13 Jun 2017 08:40:18 +0200")
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, Scott Bauer <scott.bauer@intel.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christoph,

>> But as we already set no_report_opcodes for all usb-storage and
>> quirked uas devices I think the worst offenders are already covered
>> anyway.
>
> Martin, how do we want to move ahead on this patch?

I was suggesting the VPD because that may be easier for the SAS HBA
vendors to accommodate for SATA passthrough. But we can cross that
bridge when we get to it.

For libata I'm fine with keying off a supports_opal:1 flag in
scsi_device or something to that effect. I'd just like to reduce the
risk of introducing more RSOC regressions.

-- 
Martin K. Petersen	Oracle Linux Engineering
