From: Rene Herman <rene.herman@gmail.com>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Tue, 07 Aug 2007 16:53:32 +0200
Message-ID: <46B8876C.70604@gmail.com>
References: <1186248703.3439.20.camel@localhost.localdomain>	 <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org> <1186458941.6637.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934480AbXHGO4o@vger.kernel.org>
In-Reply-To: <1186458941.6637.44.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/07/2007 05:55 AM, James Bottomley wrote:

> I really, *really* think we need a pre-release tree that consists of all 
> the upstream targetted features (i.e. all of the for the next merge 
> window git trees) and nothing else.  -mm doesn't really satisfy this, 
> because it has so much other stuff that the people I need to get testing 
> this don't trust it.

I much agree with this. I used to run -mm at least somewhat frequently if it 
included stuff I was interested in (random features, or for example latest 
ALSA) but gave that up after I had it break on something unrelated and (to 
me) uninteresting a few times too many. There's so much in there that before 
you know it you end up spending time not on that which you wanted to spend 
time on but on something completely unrelated which given a fixed amount of 
available total time (and level/spread of knowledge/interest) gets to be a 
problem.

For latest ALSA, I now sometimes look at the ALSA repositories directly but 
otherwise it seems I'm not testing much of anything before late -rc's.

Not everything going to Linus gets there by way of -mm, but perhaps it could 
help if Andrew split off -merge from -mm, where -merge contained only stuff 
(from -mm) expected to go upstream in the next merge window.

Not sure if this is proposing that other people do more work -- wouldn't 
want do to anything of the sort...

Rene.
