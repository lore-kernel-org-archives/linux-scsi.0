From: "Zou, Yi" <yi.zou-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: Request for improved commit tracking between fcoe
	and scsi trees
Date: Thu, 4 Oct 2012 21:08:01 +0000
Message-ID: <138EA028228D124A900F5E6746F3C2162F5011C6@ORSMSX102.amr.corp.intel.com>
References: <20121003192346.GA15969@hmsreliant.think-freely.org>
 <506DF0B4.9000004@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <506DF0B4.9000004-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.open-fcoe.org/mailman/options/devel>,
 <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.open-fcoe.org/mailman/listinfo/devel>,
 <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: "Love, Robert W" <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Cc: "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "devel-s9riP+hp16TNLxjTenLetw@public.gmane.org" <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

> On 10/3/2012 12:23 PM, Neil Horman wrote:
> > James, Robert-
> > 	I've been doing lots of backports of FCoE code to the RHEL tree these
> > last few months, and I've noticed something fairly irritating, and I was
> > wondering if you two could help me out with it (in fact you two are the only
> two
> > which can).  I noticed that commits which are accepted into the FCoE tree that
> > get passed upstream through the scsi tree have their commit hashes altered.  I
> > can't find any examples currently, due to the fact that you, Robert, have
> > recently re-cloned your git tree at open-fcoe.org, so all this nastiness has
> > been covered up currently, but if things don't change, this issue will quickly
> > resurface.
> >
> > Regardless, This makes it _really_ difficult to track a given patchs' traversal
> > between trees upstream, and makes my life as a distro subsystem maintainer
> fairly
> > painful.  Normally I would just live with it, but I can't see any reason why it
> > should be this way, given that git can easily prevent this with a pull.  James,
> > Robert, could you two please work out a way to provide commit hash
> consistency
> > between your trees?  It would make mine (and I'm sure many other people's)
> > lives, much easier.
> 
> I had included pull URLs in the covermails of my updates, but I haven't
> lately. I will make sure to do that from now on. Bart had a complaint
> about a misspelling in a commit message of a patch in my last update. I
> just resent that three patch series with the corrected commit message. I
> included a signed-tag to pull from in the covermail.
> 
> Consistent commit IDs between linux-fcoe.git and scsi.git would help me
> as well. It would allow me to track commit IDs from my tree all the way
> into the distros, so that I can make sure nothing gets missed.
> 
> Thanks, //Rob
> --

I definitely share with Neil's comments as I did some backporting before and
had to make sure remember whatever commit id on open-fcoe is gonna change 
later, kind of defeats the commit id's purpose. So I certainly would hope 
linux-fcoe.git always gets pulled directly from scsi.git so we have 
the full true history as reflected by the commit id when Rob commits it.

Of course, James sign-off line on each open-fcoe patch is superseded by the
pull merge commit so no information loss there, except [SCSI] prefix on the patch 

yi
