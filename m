From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Asynchronous scsi scanning
Date: Thu, 17 May 2007 11:20:23 -0600
Message-ID: <20070517172023.GL10562@parisc-linux.org>
References: <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com> <1179153096.3703.23.camel@mulgrave.il.steeleye.com> <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com> <17841.simon.1179228389@5ec7c279.invalid> <20070515120228.GI10562@parisc-linux.org> <4649E03A.1090004@simon.arlott.org.uk> <20070515172905.GJ10562@parisc-linux.org> <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com> <20070516025121.GK10562@parisc-linux.org> <a781481a0705171013j7ddc48edxfb4bdba515a3f53c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47313 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157AbXEQRUZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2007 13:20:25 -0400
Content-Disposition: inline
In-Reply-To: <a781481a0705171013j7ddc48edxfb4bdba515a3f53c@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Simon Arlott <simon@fire.lp0.eu>, James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org, "Robert P. J. Day" <rpjday@mindspring.com>

On Thu, May 17, 2007 at 10:43:06PM +0530, Satyam Sharma wrote:
> >No, it does matter.  Your suggestion doesn't work, because
> >/sys/module/scsi_mod/parameters/ belongs to the module code.  To create
> >a new attribute there, you use the module_param() code -- and there's
> >no way to have code called when your parameter is changed.

(thanks, Roland for pointing out that I'm incorrect about code being
called)

> Ok, thanks for pointing out that /sys/module/scsi_mod/parameters/wait...
> is _wrong_. Could you suggest something that would be _right_?

No, I can't, which is why I find it hard to like the idea of "use
sysfs".  I have no particular love for using a module like this, but
my preferred way (a new verb for /proc/scsi/scsi) isn't liked by others.
So here we stand.

> You're almost right here. But IMHO this is simply a case of
> doing something in some kernel subsystem in a proper/better
> way than it is being done presently.
> 
> Anyway, like I said on another thread, discussions here tend to be
> most productive only over code, so I'll try and make a patch to do
> this some other way.

Come up with a sensible suggestion, and I'll listen to you.  Code isn't
the issue.  API is the issue.
