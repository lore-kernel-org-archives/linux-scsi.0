From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Bugme-new] [Bug 11792] New: Oops when reading /proc/megaraid/hba0/diskdrives-ch*
Date: Tue, 21 Oct 2008 13:54:20 -0600
Message-ID: <20081021195419.GR26184@parisc-linux.org>
References: <bug-11792-10286@http.bugzilla.kernel.org/> <20081021124701.3d639c4e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:48313 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYJUTyV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2008 15:54:21 -0400
Content-Disposition: inline
In-Reply-To: <20081021124701.3d639c4e.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, sumantp@lsil.com, bo.yang@lsi.com, bugme-daemon@bugzilla.kernel.org, pterjan@gmail.com

On Tue, Oct 21, 2008 at 12:47:01PM -0700, Andrew Morton wrote:
> > Latest working kernel version: 2.6.24
> > Earliest failing kernel version: 2.6.27-rc8
> 
> It's a regression.
> 
> > Pid: 2319, comm: diff Not tainted (2.6.27-server-0.rc8.2mnb #1)

It's also a distro kernel by the looks of things.  Can it be reproduced
with an upstream kernel?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
