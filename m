From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Tue, 17 Jan 2017 14:44:22 -0500
Message-ID: <yq1shohmpyh.fsf@oracle.com>
References: <20161229080250.GA11605@infradead.org>
        <1483226343.2518.32.camel@linux.vnet.ibm.com>
        <1483280506.5512.1.camel@sandisk.com>
        <20170101.113311.417107391370623850.davem@davemloft.net>
        <1483292364.2345.5.camel@linux.vnet.ibm.com>
        <yq1y3ypgd7m.fsf@oracle.com>
        <1484596878.2540.58.camel@HansenPartnership.com>
        <CAK=zhgpFKLWUpQMp8VOfmHsUCQiF6E54FBP2juaHYNVvR+TOmw@mail.gmail.com>
        <20170117141525.GA32219@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:49817 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbdAQU7R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2017 15:59:17 -0500
In-Reply-To: <20170117141525.GA32219@lst.de> (Christoph Hellwig's message of
        "Tue, 17 Jan 2017 15:15:25 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, David Miller <davem@davemloft.net>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, jbaron@akamai.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, sagi@grimberg.me, Sathya Prakash <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Chaitra Basappa <chaitra.basappa@broadcom.com>, dledford@redhat.com, Ingo Molnar <mingo@kernel.org>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> On Tue, Jan 17, 2017 at 07:43:51PM +0530, Sreekanth Reddy wrote:
>> [Sreekanth] Just for readability purpose, can use use "if
>> (test_bit(0, &sas_device_priv_data->ata_command_pending)" instead of
>> "if (sas_device_priv_data->ata_command_pending)".  Since while
>> setting & clearing the bit we are using atomic bit operations. I
>> don't see any issue functionality wise.

Christoph> I agree.  Also while we're into nitpicking - it would be good
Christoph> to give bit 0 of the bitmap a name instead of hardcoding the
Christoph> 0.

I tweaked the test case. We can name the bit later if more flags are
needed (and in that case the ata_command_pending would need to get
renamed too).

In any case. This issue has taken waaay too long to get resolved so the
patch is now queued up in 4.10/scsi-fixes.

Thanks everyone!

-- 
Martin K. Petersen	Oracle Linux Engineering
