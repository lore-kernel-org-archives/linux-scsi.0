From: Joel Becker <jlbec@evilplan.org>
Subject: Re: copy offload support in Linux - new system call needed?
Date: Fri, 16 Dec 2011 00:00:23 -0800
Message-ID: <20111216080022.GA5183@noexit.corp.google.com>
References: <4EE8F75F.6070800@gmail.com>
 <20111214192739.GN2203@ZenIV.linux.org.uk>
 <4EE8FC2E.3010207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4EE8FC2E.3010207@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 14, 2011 at 02:42:38PM -0500, Ric Wheeler wrote:
> On 12/14/2011 02:27 PM, Al Viro wrote:
> >On Wed, Dec 14, 2011 at 02:22:07PM -0500, Ric Wheeler wrote:
> >
> >>We had an active thread a couple of years back that came out of the
> >>reflink work and, at the time, there seemed to be moderately
> >>positive support for adding a new system call that would fit this
> >>use case (Joel Becker's copyfile()).
> >>
> >>Can we resurrect this effort? Is copyfile() still a good way to go,
> >>or should we look at other hooks?
> >copyfile(2) is probably a good way to go, provided that we do _not_
> >go baroque as it had happened the last time syscall had been discussed.
> >
> >IOW, to hell with progress reports, etc. - just a fastpath kind of
> >thing, in the same kind of relationship to cp(1) as rename(2) is to mv(1).
> >If it works - fine, if not - caller has to be ready to deal with handling
> >cross-device case anyway.
> 
> I think that this approach makes a lot of sense. Most of the
> devices/targets that support the copy offload, will do it in very
> reasonable amounts of time.
> 
> Let me see if I can dig up some of the presentations from the NetApp
> guys who presented overviews or the specifications from the IETF and
> T10....

	Whee!  I've been down the rabbit hole, but I've promised myself
to get the updated patch out soon.  I know that Trond et al are probably
wondering what happened to the patch.  more soon.

Joel

-- 

Life's Little Instruction Book #207

	"Swing for the fence."

			http://www.jlbec.org/
			jlbec@evilplan.org
