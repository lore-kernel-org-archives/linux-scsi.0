From: Jens Axboe <axboe@kernel.dk>
Subject: Re: lk 3.17-rc4 blk_mq large write problems
Date: Wed, 10 Sep 2014 12:26:57 -0600
Message-ID: <541097F1.8030808@kernel.dk>
References: <540FCB96.8000606@interlog.com> <20140910154144.GA22296@infradead.org> <541080B5.8080505@kernel.dk> <20140910180957.GA17495@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39142 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaIJS0t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 14:26:49 -0400
Received: by mail-pa0-f43.google.com with SMTP id fa1so7504500pad.16
        for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2014 11:26:49 -0700 (PDT)
In-Reply-To: <20140910180957.GA17495@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 09/10/2014 12:09 PM, Christoph Hellwig wrote:
> On Wed, Sep 10, 2014 at 10:47:49AM -0600, Jens Axboe wrote:
>> BTW, please don't mix up the REQ_END and ->queue_rq() changes with the
>> changed start_request API.
> 
> I have to.  It's set by start_request, so we need to pass down the last
> argument to keep the old behavior.  And once we pass the argument we
> can just it directly.

It could still be done in the caller, but arguably, you'd have to do it
twice unless the ->queue_rq() call was rolled into a function.

-- 
Jens Axboe

