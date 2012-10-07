From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Request for improved commit tracking between fcoe and scsi trees
Date: Sun, 07 Oct 2012 11:59:29 +0100
Message-ID: <1349607569.2541.23.camel@dabdike.int.hansenpartnership.com>
References: <20121003192346.GA15969@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54377 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700Ab2JGK7c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Oct 2012 06:59:32 -0400
In-Reply-To: <20121003192346.GA15969@hmsreliant.think-freely.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org, Robert Love <robert.w.love@intel.com>

On Wed, 2012-10-03 at 15:23 -0400, Neil Horman wrote:
> James, Robert-
> 	I've been doing lots of backports of FCoE code to the RHEL tree these
> last few months, and I've noticed something fairly irritating, and I was
> wondering if you two could help me out with it (in fact you two are the only two
> which can).  I noticed that commits which are accepted into the FCoE tree that
> get passed upstream through the scsi tree have their commit hashes altered.  I
> can't find any examples currently, due to the fact that you, Robert, have
> recently re-cloned your git tree at open-fcoe.org, so all this nastiness has
> been covered up currently, but if things don't change, this issue will quickly
> resurface.
> 
> Regardless, This makes it _really_ difficult to track a given patchs' traversal 
> between trees upstream, and makes my life as a distro subsystem maintainer fairly
> painful.  Normally I would just live with it, but I can't see any reason why it
> should be this way, given that git can easily prevent this with a pull.  James,
> Robert, could you two please work out a way to provide commit hash consistency
> between your trees?  It would make mine (and I'm sure many other people's)
> lives, much easier.

I'm reluctant to commit to any tracking process that relies on stable
commit ids simply because they're illusory in git:  if we find a bug in
a commit (or even worse a bisection failure) in a tree, we fix it there,
which causes the commit id to change.

The way I do this type of tracking is via the Subject: line ... why
can't you use that?

James


