From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/6] scsi: handle special return codes for ABORTED COMMAND
Date: Fri, 20 Apr 2018 19:15:38 -0400
Message-ID: <yq1efj9h3l1.fsf@oracle.com>
References: <20180417233511.6573-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180417233511.6573-1-mwilck@suse.com> (Martin Wilck's message
        of "Wed, 18 Apr 2018 01:35:05 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org


Martin,

> Here is another attempt to handle the special return codes for ABORTED
> COMMAND for certain SCSI devices. Following MKP's recommendation, I've
> created two new BLIST flags, simplifying the code in scsi_error.c
> compared to the previous versions. Rather than using "free" bits, I
> increased the length of blist_flag_t to 64 bit, and used previously
> unused bits. I also added checking for obsolete and unused bits.
>
> For the blist_flag_t size increase, I used sparse to try and avoid
> regressions; that necessitated fixing sparse's errors for the current
> code first.

Much better, thanks for reworking this. Applied to 4.18/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
