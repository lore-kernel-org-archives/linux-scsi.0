From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Mon, 16 Jan 2017 16:01:30 -0500
Message-ID: <yq14m0ylnx1.fsf@oracle.com>
References: <20161229080250.GA11605@infradead.org>
        <1483226343.2518.32.camel@linux.vnet.ibm.com>
        <1483280506.5512.1.camel@sandisk.com>
        <20170101.113311.417107391370623850.davem@davemloft.net>
        <1483292364.2345.5.camel@linux.vnet.ibm.com>
        <yq1y3ypgd7m.fsf@oracle.com>
        <1484596878.2540.58.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484596878.2540.58.camel@HansenPartnership.com> (James
        Bottomley's message of "Mon, 16 Jan 2017 12:01:18 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, David Miller <davem@davemloft.net>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, jbaron@akamai.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, sagi@grimberg.me, Sathya Prakash <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Chaitra Basappa <chaitra.basappa@broadcom.com>, dledford@redhat.com, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Ingo Molnar <mingo@kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> Subject: [PATCH] scsi: mpt3sas: fix hang on ata passthrough
James> commands

James> mpt3sas has a firmware failure where it can only handle one pass
James> through ATA command at a time.  If another comes in, contrary to
James> the SAT standard, it will hang until the first one completes
James> (causing long commands like secure erase to timeout).  The
James> original fix was to block the device when an ATA command came in,
James> but this caused a regression with

Broadcom folks: Please test and ack as soon as possible so we can get
this fix queued up.

Ingo: Since you appear to have hardware, it would be great if you could
test James' v3 (https://patchwork.kernel.org/patch/9519383/). Sorry for
the inconvenience.

-- 
Martin K. Petersen	Oracle Linux Engineering
