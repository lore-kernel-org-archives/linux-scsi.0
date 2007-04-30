From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH 4/4] bidi support: bidirectional request
Date: Mon, 30 Apr 2007 09:05:57 -0400
Message-ID: <4635E9B5.1020708@rtr.ca>
References: <46225E18.7070404@panasas.com> <462261E8.5090005@panasas.com> <200704281948.l3SJm9jS001428@mbox.iij4u.or.jp> <4634BE6B.3000808@panasas.com> <1177872588.3688.79.camel@mulgrave.il.steeleye.com> <20070430111157.GI21015@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070430111157.GI21015@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <tomof@acm.org>, akpm@osdl.org, michaelc@cs.wisc.edu, hch@infradead.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, bhalevy@panasas.com
List-Id: linux-scsi@vger.kernel.org

Jens Axboe wrote:
>
> So basically just add a struct request pointer, so you can do rq =
> rq->next_rq or something for the next data phase. I bet this would be a
> LOT less invasive as well, and we can get by with a few helpers to
> support it.

Hey, I want a way to issue those (linked requests) from userspace (SG_IO), too.
Specifically for use with the new SMART Command Transport (SCT) feature set
on modern SATA drives.  As well as for a disk recovery utility I'm working on.

Sounds generally useful, that.


