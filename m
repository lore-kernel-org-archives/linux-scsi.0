From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Promise 'stex' driver
Date: Thu, 20 Jul 2006 20:16:23 -0400
Message-ID: <44C01CD7.4030308@garzik.org>
References: <NONAMEBMcvsq9IcVux1000001f9@nonameb.ptu.promise.com>	 <44BFF539.4000700@garzik.org> <1153439728.4754.19.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030422AbWGUAQ1@vger.kernel.org>
In-Reply-To: <1153439728.4754.19.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Ed Lin <ed.lin@promise.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, hch <hch@infradead.org>, linux-kernel <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>, promise_linux <promise_linux@promise.com>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2006-07-20 at 17:27 -0400, Jeff Garzik wrote:
>> Since _no individual SCSI driver_ uses the block layer
>> tagging, it is likely that some instability and core kernel
>> development
>> will occur, in order to make that work.
> 
> That's not quite true: 53c700 and tmscsim both use it ... I could with
> the usage were wider, but at least 53c700 has pretty regular and
> constant usage ... enough I think to validate the block tag code (it's
> been using it for the last three years).

Not for the case being discussed in this thread, adapter-wide tags.

AFAICS, no file in include/scsi/* or drivers/scsi/* ever calls 
blk_queue_init_tags() with a non-NULL third arg.

The block tagging capability being discussed here is poorly validated 
due to overall underuse, and its never been used in SCSI AFAIK.

	Jeff
