From: Jens Axboe <axboe@suse.de>
Subject: Re: cdrecord: Cannot allocate memory. Cannot get SCSI I/O buffer.
Date: Fri, 13 Jan 2006 10:52:23 +0100
Message-ID: <20060113095221.GT3945@suse.de>
References: <200601121322.17458.T.Maguin@web.de> <200601121352.16717.T.Maguin@web.de> <m31wzdv4zi.fsf@merlin.emma.line.org> <200601130923.45539.T.Maguin@web.de> <20060113090257.GQ3945@suse.de> <m34q48qxd2.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:58980 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S932620AbWAMJuW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 04:50:22 -0500
Content-Disposition: inline
In-Reply-To: <m34q48qxd2.fsf@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <matthias.andree@gmx.de>
Cc: Thomas Maguin <T.Maguin@web.de>, linux-scsi@vger.kernel.org

On Fri, Jan 13 2006, Matthias Andree wrote:
> Jens Axboe <axboe@suse.de> writes:
> 
> > On Fri, Jan 13 2006, Thomas Maguin wrote:
> >> This patch is working with alpha04 on my mashine:
> >> http://de.geocities.com/linux_piewie/download/alpha04.txt
> >
> > So any particular reason you think this is a kernel bug??
> 
> Perhaps because <http://de.geocities.com/linux_piewie/download/Readme.txt>
> 
> contains this text:
> 
> "3. solution for the root problem, not existent for kernel >= 2.6.14-rc2"

Dunno if that is what you meant, but it states that >= 2.6.14-rc2 fixes
the root problem - your line states that a solution for kernel >=
2.6.14-rc2 is non-existant.

> OTOH, if 2.6.14 and 2.6.15 are fixed, why would a kernel developer take
> interest? 2.6.X isn't "stable" after all... as fiercely discussed on

Well there's nothing to fix if it works in newer kernels, is there? I
can't travel back in time and make sure that eg 2.6.10 works.

-- 
Jens Axboe

