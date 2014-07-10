From: Jens Axboe <axboe@kernel.dk>
Subject: Re: scsi-mq V2
Date: Thu, 10 Jul 2014 15:52:49 +0200
Message-ID: <53BE9AB1.6090603@kernel.dk>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <20140708144829.GA5539@infradead.org> <53BD7041.5010300@interlog.com> <53BD9A24.7010203@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net> <20140710062040.GB20146@infradead.org> <20140710133609.GO12478@kvack.org> <20140710135051.GA28227@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59107 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbaGJNww (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2014 09:52:52 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so516139wgh.15
        for <linux-scsi@vger.kernel.org>; Thu, 10 Jul 2014 06:52:51 -0700 (PDT)
In-Reply-To: <20140710135051.GA28227@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Benjamin LaHaise <bcrl@kvack.org>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 2014-07-10 15:50, Christoph Hellwig wrote:
> On Thu, Jul 10, 2014 at 09:36:09AM -0400, Benjamin LaHaise wrote:
>> There is one possible concern that could be exacerbated by other changes in
>> the system: if the application is running close to the bare minimum number
>> of requests allocated in io_setup(), the per cpu reference counters will
>> have a hard time batching things.  It might be worth testing with an
>> increased number of requests being allocated if this is the case.
>
> Well, Robert said reverting the two aio commits didn't help.  Either he
> didn't manage to boot into the right kernel, or we need to look
> elsewhere for the culprit.

Rob, let me know what scsi_debug setup you use, and I can try and 
reproduce it here as well.

-- 
Jens Axboe

