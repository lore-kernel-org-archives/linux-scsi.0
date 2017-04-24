From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 10/10] scsi: Implement blk_mq_ops.show_rq()
Date: Mon, 24 Apr 2017 19:19:50 -0400
Message-ID: <yq1zif5fl61.fsf@oracle.com>
References: <20170421234026.18970-1-bart.vanassche@sandisk.com>
        <20170421234026.18970-11-bart.vanassche@sandisk.com>
        <yq1k269ij5f.fsf@oracle.com> <1493070575.3394.19.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1493070575.3394.19.camel@sandisk.com> (Bart Van Assche's message
        of "Mon, 24 Apr 2017 21:49:37 +0000")
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "hare@suse.com" <hare@suse.com>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org


Bart,

> SCSI tracing has to be enabled before a test is started, produces a
> huge amount of data, and deriving state information from a huge trace
> is far from easy. The information in debugfs provides an easy to read
> overview of the current state without having to analyze megabytes of
> traces, without introducing any slowdown and without having to enable
> any tracing mechanism from beforehand.

Fair enough. Just seems like there's an obvious overlap in plumbing.
Don't know if that can be leveraged instead of introducing something
completely new?

-- 
Martin K. Petersen	Oracle Linux Engineering
