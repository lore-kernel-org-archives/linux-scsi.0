From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 10/10] scsi: Implement blk_mq_ops.show_rq()
Date: Tue, 25 Apr 2017 12:40:10 -0400
Message-ID: <yq1efwgfnkl.fsf@oracle.com>
References: <20170421234026.18970-1-bart.vanassche@sandisk.com>
        <20170421234026.18970-11-bart.vanassche@sandisk.com>
        <yq1k269ij5f.fsf@oracle.com> <1493070575.3394.19.camel@sandisk.com>
        <yq1zif5fl61.fsf@oracle.com>
        <20170424232359.GA21578@vader.DHCP.thefacebook.com>
        <yq1r30hfkiv.fsf@oracle.com> <1493077595.3394.32.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1493077595.3394.32.camel@sandisk.com> (Bart Van Assche's message
        of "Mon, 24 Apr 2017 23:46:36 +0000")
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "osandov@osandov.com" <osandov@osandov.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "hare@suse.com" <hare@suse.com>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org


Bart,

>> I was merely objecting to the fact that we already have umpteen existing
>> interfaces for displaying SCSI command information.

> Do you perhaps want me to change the for-loop into a call to
> __scsi_format_command()?

If possible, I would love to see some commonality in the per-command
information regardless of whether it is displayed due to SCSI logging,
SCSI tracing or an error condition.

-- 
Martin K. Petersen	Oracle Linux Engineering
