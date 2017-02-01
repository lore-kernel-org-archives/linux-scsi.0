From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: remove the cmd_type field from struct request
Date: Wed, 01 Feb 2017 11:37:26 +0100
Message-ID: <2642348.4a930XfY9Y@amdc3058>
References: <1485878251-6107-1-git-send-email-hch@lst.de>
 <bbe16fc1-5652-bbc2-03a5-0298c3f16645@kernel.dk>
 <CGME20170201103729epcas1p12708473d0e5257bef65e1d92712af885@epcas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <bbe16fc1-5652-bbc2-03a5-0298c3f16645@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi,

On Tuesday, January 31, 2017 10:02:50 AM Jens Axboe wrote:
> On 01/31/2017 07:57 AM, Christoph Hellwig wrote:
> > [1] which were a pain in the ass to untangle and debug during development,
> > it's really time for it to die..
> 
> Outside of the patch series in question, how to we expedite the
> euthanasia of IDE? What explicit features/support are we missing through

When it comes to missing features/support there is still
number of non-x86 host drivers not ported to libata (I'm
slowly working on this as a side-task, any help would be
much appreciated).

> libata that would need to be added, before we can git rm drivers/ide/ ?

I was trying to start the removal with [1] last year but
it has been NAK-ed by DaveM who seems to want to keep
drivers/ide/ forever [2].

[1] https://lkml.org/lkml/2016/2/4/409
[2] https://lkml.org/lkml/2016/12/8/423

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

