From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 2.5.x add back missing scsi_queue_next_request calls
Date: Fri, 21 Mar 2003 14:20:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E7B6610.90707@splentec.com>
References: <20030319184444.A9694@beaverton.ibm.com> <3E7A317A.702@splentec.com> <3E7A529C.5050607@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> 
> If you don't like what Patrick is proposing, please explain
> why.

I think I _did_ explain why: contamination of scsi_put_command().
I also think that I explain it in quite a dry and formal way
with examples, trying really hard to convey what I meant.

Please feel free to give me pointers on where I ``missed the mark''.

> [Rather than re-explain, you could supply a url to the
> prior post in the marc.theaimsgroup.com archive.]

On slab allocation:
http://MARC.10East.com/?l=linux-scsi&m=104438145823604&w=2
The whole message is about that.

The second ``Point 2'', on ``change'', ``new'' and ``before'':
http://MARC.10East.com/?l=linux-scsi&m=104387923212007&w=2
Excerpt:
	2. This is a pickle and might I mention that Doug's queue depth
	changes were *for a reason*, so there's no point in saying
	``the way it was before''.  Furthermore ``the number of outstanding
	commands'' is ambiguous and any which way it is it, is NOT enough.
	I.e. outstaning in LLDD, oustanding free, etc. -- it just doesn't
	compute.
This was about the ``way it was before'', i.e. we should not improve
SCSI Core by means of its old workings, but by means of new infrastructure...
(Here's I'd be repeating myself, as I've said those things before on
linux-scsi... sorry, no time to search the archives now.)

> I don't
> think boldface exclamations are required.

I was just trying to make myself clear.

> Naturally you are at liberty to present another patch which
> merges what you are trying to do with Patrick's work.

No, I don't want to.  This has to do with managing ppl and the reasons are
more or less as follows: Patrick is already doing the work -- let him
continue to do it, he's doing a great job;  I don't believe in taking someone's
patch (idea) and rewriting it and resubmitting it as my own.  If they step
out of line, I'd let them know, they can correct it, resubmit the patch, and
thusly continue to do the great work they've been doing.

This way they learn, get more enthusiastic and feel really good about themselves
and next time they'll do an even better job.

If you guys were closer, I'd all buy you a beer! :-)

-- 
Luben


