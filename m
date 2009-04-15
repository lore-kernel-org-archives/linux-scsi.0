From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: LSF Papers online?
Date: Wed, 15 Apr 2009 15:38:20 +0200
Message-ID: <200904151538.20546.bzolnier@gmail.com>
References: <49E335BA.3020103@panasas.com> <200904150009.06539.bzolnier@gmail.com> <20090415102829.7fec55f2@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090415102829.7fec55f2@lxorguk.ukuu.org.uk>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Jonathan Corbet <corbet@lwn.net>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Zach Brown <zach.brown@oracle.com>, Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wednesday 15 April 2009 11:28:29 Alan Cox wrote:
> > I just wanted to have clear vision of the process instead of "lets merge
> > it now and worry about real users later".
> 
> There was a simple vision which was to provide full coverage for all the
> relevant ATA controllers using the libata core ASAP and leave the old IDE
> code "as is". That was what was done.

You took the "shortcut" instead of fixing the issue the "proper" way.

Namely, you defined "relevant" and "full coverage" as you wanted.

Depending on the level of difficulty of the task.

Wasn't IDE PMAC relevant back in 2005?

It was much more relevant than CMD640 or legacy VLB drivers that you ported.

It is 2009 now and IDE PMAC is still much more relevant than some other
stuff that you're working on.

Wasn't 32-bit PIO important for embedded systems back then?
[it happened only recently]

You also threw in a bunch of regressions because you didn't start from
fixing IDE host drivers in incremental evolutionary way.

You didn't even care to backport some obvious/critical fixes to IDE,
the same IDE that all distributions (including _your_ past employer)
were still shipping.

Yes, doing it your way was faster for _you_ and gave _you_ huge competition
advantage but prevented any reasonable review/help from _other_ people.

Reinventing the whole subsystem is not a single person project.

It is just physically impossible to do it properly.

The complexity and the scale is too large and there will be always things
that you miss or that other people are better at.

> > Every uncomfortable technical issue raised was addressed with direct
> > "IDE is teh crap" shouting 
> 
> Sorry but you are re-inventing history here. The old IDE layer was crap,
> and for sound technical reasons including the error handling and the
> horrible locking problems from the design level up caused by the
> reset/error/timeout handling paths and the polled speed change on CRC
> error change down.

That was not the issue raised.

> I spent years working on that stuff. Throwing it all away was not my idea

So what?

This doesn't make you special in any way.

Few other people had similar experiences.

> of fun, but it was clearly the right technical decision. I'm very happy
> with the state of libata PATA.

Maybe it is the time to retire from kernel hacking then? ;)

You see, I'm not happy with the state of IDE, libata, SCSI, block
and many other things.  I know that I'll _never_ be.  I also bet that
most of people working with me feel in the exactly same way.

More seriously, it is 2009 now.

Four years after initial libata PATA introduction and I could still
spend few next weeks sending one IDE -> libata regression fix per day,
ranging from possible data corruption through lack of hardware support
to duplicated code [most of issues can be tracked back to 2005].

However I simply do not care.

I don't need libata PATA.

I don't use it, I'm not paid to work on it and it is not my project.

It seems that it I'm not the only one who misunderstood the free software.

If you are not interested in people wanting to improve _your_ project
then we can end up the discussion here.

You may not like me but this is pretty lame excuse for denying me
merit and in turn damaging _your_ own project.

Re-read my previous mail and ping me when you are back to the rational
thinking.

Till then I'm done with this topic.
