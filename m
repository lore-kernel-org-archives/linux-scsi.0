From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Request for improved commit tracking between fcoe and scsi trees
Date: Sun, 07 Oct 2012 12:01:43 +0100
Message-ID: <1349607703.2541.25.camel@dabdike.int.hansenpartnership.com>
References: <20121003192346.GA15969@hmsreliant.think-freely.org>
	 <506DF0B4.9000004@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54396 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681Ab2JGLBr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Oct 2012 07:01:47 -0400
In-Reply-To: <506DF0B4.9000004@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Love, Robert W" <robert.w.love@intel.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2012-10-04 at 20:25 +0000, Love, Robert W wrote:
> On 10/3/2012 12:23 PM, Neil Horman wrote:
> > James, Robert-
> > 	I've been doing lots of backports of FCoE code to the RHEL tree these
> > last few months, and I've noticed something fairly irritating, and I was
> > wondering if you two could help me out with it (in fact you two are the only two
> > which can).  I noticed that commits which are accepted into the FCoE tree that
> > get passed upstream through the scsi tree have their commit hashes altered.  I
> > can't find any examples currently, due to the fact that you, Robert, have
> > recently re-cloned your git tree at open-fcoe.org, so all this nastiness has
> > been covered up currently, but if things don't change, this issue will quickly
> > resurface.
> >
> > Regardless, This makes it _really_ difficult to track a given patchs' traversal
> > between trees upstream, and makes my life as a distro subsystem maintainer fairly
> > painful.  Normally I would just live with it, but I can't see any reason why it
> > should be this way, given that git can easily prevent this with a pull.  James,
> > Robert, could you two please work out a way to provide commit hash consistency
> > between your trees?  It would make mine (and I'm sure many other people's)
> > lives, much easier.
> 
> I had included pull URLs in the covermails of my updates, but I haven't 
> lately. I will make sure to do that from now on.

Actually, I'm happy to do a pull based process with signed tags going
forwards.  However:

>  Bart had a complaint 
> about a misspelling in a commit message of a patch in my last update. I 
> just resent that three patch series with the corrected commit message. I 
> included a signed-tag to pull from in the covermail.

That change changed the commit id and gives a graphic illustration of
why any tracking process based on git commit ids is wrong.

James


