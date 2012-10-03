From: Neil Horman <nhorman@tuxdriver.com>
Subject: Request for improved commit tracking between fcoe and scsi trees
Date: Wed, 3 Oct 2012 15:23:47 -0400
Message-ID: <20121003192346.GA15969@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39593 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab2JCTX6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2012 15:23:58 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Robert Love <robert.w.love@intel.com>

James, Robert-
	I've been doing lots of backports of FCoE code to the RHEL tree these
last few months, and I've noticed something fairly irritating, and I was
wondering if you two could help me out with it (in fact you two are the only two
which can).  I noticed that commits which are accepted into the FCoE tree that
get passed upstream through the scsi tree have their commit hashes altered.  I
can't find any examples currently, due to the fact that you, Robert, have
recently re-cloned your git tree at open-fcoe.org, so all this nastiness has
been covered up currently, but if things don't change, this issue will quickly
resurface.

Regardless, This makes it _really_ difficult to track a given patchs' traversal 
between trees upstream, and makes my life as a distro subsystem maintainer fairly
painful.  Normally I would just live with it, but I can't see any reason why it
should be this way, given that git can easily prevent this with a pull.  James,
Robert, could you two please work out a way to provide commit hash consistency
between your trees?  It would make mine (and I'm sure many other people's)
lives, much easier.

Thanks & Regards
Neil

