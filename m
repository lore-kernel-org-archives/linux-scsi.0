From: Olaf Hering <olh@suse.de>
Subject: Re: 2.6.15-git12, slab corruption in ipr
Date: Mon, 30 Jan 2006 11:46:13 +0100
Message-ID: <20060130104613.GA26551@suse.de>
References: <20060117000533.GA27473@suse.de> <43CE8C26.4000202@us.ibm.com> <20060119210514.GA7118@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:37348 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932207AbWA3KqP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 05:46:15 -0500
Content-Disposition: inline
In-Reply-To: <20060119210514.GA7118@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Brian J King <bjking1@us.ibm.com>

 On Thu, Jan 19, Olaf Hering wrote:

>  On Wed, Jan 18, Brian King wrote:
> 
> > Olaf Hering wrote:
> > > I tested the current Linus tree + a few SuSE patches on a p710. There is
> > > some slab corruption.  Will check if plain Linus tree gives the same...
> > 
> > I can't recreate the problem on my p5... Can you recreate it with the
> > current git tree without any other patches?
> 
> I tried rc1-git1 with ipr compiled in and did not see it.
> The system was used for other testing and will be busy for a bit. I will
> look at it later.

I see it not only on ipr systems, also on JS20 with the media tray
assigned. It doesnt reproduce all the time. I'm currently down to 'only
20 patches applied from our CVS'. The symptoms differ, I suspect the bug
is also present in mainline.

Just to let you know. Still looking.


...
Freeing unused kernel memory: 260k freed
Starting udevd
Creating devices
Loading sd_mod
SCSI subsystem initialized
Slab corruption: start=c000000000455000, len=4096
d80: c0 00 00 00 00 45 5d 80 c0 00 00 00 00 45 5d 80
Loading loop
loop: loaded (max 255 devices)
Loading ipr
...

-- 
short story of a lazy sysadmin:
 alias appserv=wotan
