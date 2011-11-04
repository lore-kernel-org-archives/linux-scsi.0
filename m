From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-next] block: don't call blk_drain_queue() if
 elevator is not up
Date: Fri, 4 Nov 2011 07:30:05 -0700
Message-ID: <CAOS58YPMpbH_ex97g25G1375HPrphdXzuOe=DR78b4S07nJugw@mail.gmail.com>
References: <4EB2BC88.3070105@suse.cz>
	<20111103161436.GJ4417@google.com>
	<20111103162634.GK4417@google.com>
	<4EB2D441.9040708@kernel.dk>
	<20111103211253.GO4417@google.com>
	<4EB39E63.9020804@kernel.dk>
	<CAOS58YM-6v2nriMv8izhePD04YiJe0s7wqwWw=Dc9w-4er_McA@mail.gmail.com>
	<4EB3F680.1070309@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41172 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572Ab1KDOaH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2011 10:30:07 -0400
In-Reply-To: <4EB3F680.1070309@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Slaby <jslaby@suse.cz>, "James E.J. Bottomley" <jejb@parisc-linux.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>

Hello,

On Fri, Nov 4, 2011 at 7:28 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> Hmmm... yeah, the first and second patchsets kinda go together but
>> well the first one definitely is pretty good bug fix without others,
>> so I guess that split isn't too bad either. Alright, no objection.
>
> OK, I'll push off what I have now and then we can queue #2 up shortly. I
> would probably prefer pushing the cfq locking cleanup to 3.3 to get some
> more testing time on that, but it all depends on what your level of
> confidence in it is?

Not that confident. Those definitely belong to the next window.

Thank you.

-- 
tejun
