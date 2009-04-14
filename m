From: Jeff Garzik <jeff@garzik.org>
Subject: Re: LSF Papers online?
Date: Tue, 14 Apr 2009 19:14:54 -0400
Message-ID: <49E518EE.1000104@garzik.org>
References: <49E335BA.3020103@panasas.com> <200904141654.24067.bzolnier@gmail.com> <20090414175441.5ce1f59d@lxorguk.ukuu.org.uk> <200904150009.06539.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200904150009.06539.bzolnier@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jonathan Corbet <corbet@lwn.net>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Zach Brown <zach.brown@oracle.com>, Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> We actually used quite a lot of libata PATA changes on the host driver front
> (though because of the lack of incremental libata PATA changes and the need
> to fix some IDE specific issues first this was not that easy) so maybe if we
> could agree on some mid-point way back in 2005 we would be in a completely
> different place today.
> 
> Lets not repeat the history again.
> 
>>> The fact that it is much harder to do nowadays than in 2004-2005 (without
>>> ATAPI support, PATA support and heavy dependence on SCSI infrastructure)
>>> is only _your_ fault.
>> Really - you could have contributed too. Anyway I wrote most of the PATA
>> bits, Tejun wrote a ton of stuff including EH, and Albert Lee wrote
>> chunks of it too.
> 
> I did a bit work.  Check your host drivers. :)
> 
>> So that would be Red Hat, SuSE and IBM who are to blame right, not just
>> Jeff ? Sounds like a conspiracy to me ;)
> 
> There is no conspiracy there.
> 
> Just the good old game known from elsewhere.
> 
> Top layer modern day kernel hacking is based on business principles.
> 
> However, like they say "Hate the Game, Not the Player". :)
> 
> There is really nothing wrong with it as long as we don't state
> otherwise to new people so they are fully aware of the situation.

Actually, libata got started even before I was at Red Hat.  As I alluded 
to at the bottom of the libata announcement[1], rewriting the IDE driver 
into something clean and modern was one of my Projects To Do Before I 
Die -- that is, projects not sponsored by any business or group or 
conspiracy, but rather things I feel personally are very important to 
the advancement of Linux.

And I have been very fortunate that other talented hackers (including 
yourself) have been willing to work on one of my dream projects.

	Jeff



[1] http://www.kernel-traffic.org/kernel-traffic/kt20030616_219.html#7

