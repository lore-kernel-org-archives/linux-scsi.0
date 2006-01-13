From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Bug] crash with kernel >= 2.6.14 with k3b and scsi driver
Date: Fri, 13 Jan 2006 06:06:43 -0700
Message-ID: <20060113130643.GO19769@parisc-linux.org>
References: <Pine.LNX.4.62.0601131215550.5667@tigerclaw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:25485 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1422654AbWAMNGn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 08:06:43 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0601131215550.5667@tigerclaw.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Srdjan Todorovic <todorovic.s@googlemail.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Jan 13, 2006 at 12:27:01PM +0000, Srdjan Todorovic wrote:
> I created a bug report with more information, but I think I messed
> up the bug report procedure (it's my first time, sorry) as linux-scsi
> list is not in the CC. This can probably be corrected very easily but
> I wasn't sure it was going to spam you all.
> 
> Bugzilla bug ID: 5776

You don't actually say what happens.  Does the machine hang?
Spontaneously reboot?  Do you get a panic?  How about an oops?  Have you
tried attaching a serial console?
