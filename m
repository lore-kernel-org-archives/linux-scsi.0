From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: cdrecord: Cannot allocate memory. Cannot get SCSI I/O buffer.
Date: Fri, 13 Jan 2006 11:08:16 +0100
Message-ID: <20060113100816.GA9324@merlin.emma.line.org>
References: <200601121322.17458.T.Maguin@web.de> <200601121352.16717.T.Maguin@web.de> <m31wzdv4zi.fsf@merlin.emma.line.org> <200601130923.45539.T.Maguin@web.de> <20060113090257.GQ3945@suse.de> <m34q48qxd2.fsf@merlin.emma.line.org> <20060113095221.GT3945@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.21]:9344 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1161525AbWAMKIW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 05:08:22 -0500
Content-Disposition: inline
In-Reply-To: <20060113095221.GT3945@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Matthias Andree <matthias.andree@gmx.de>, Thomas Maguin <T.Maguin@web.de>, linux-scsi@vger.kernel.org

Jens Axboe schrieb am 2006-01-13:

> On Fri, Jan 13 2006, Matthias Andree wrote:

> > Perhaps because <http://de.geocities.com/linux_piewie/download/Readme.txt>
> > 
> > contains this text:
> > 
> > "3. solution for the root problem, not existent for kernel >= 2.6.14-rc2"
> 
> Dunno if that is what you meant, but it states that >= 2.6.14-rc2 fixes
> the root problem - your line states that a solution for kernel >=
> 2.6.14-rc2 is non-existant.

Usually the reference would "root problem": problem fixed as of 2.6.14-rc2.

I don't know if that's what the original author meant, but chances are
the problem was fixed in the kernel after being introduced between 2.6.7
and 2.6.10 somewhen. May have been 2.6.8[.1], but don't anyone quote me
on that figure.

> Well there's nothing to fix if it works in newer kernels, is there? I
> can't travel back in time and make sure that eg 2.6.10 works.

Let's not open this can of "stable kernel" worms here in -scsi@.

-- 
Matthias Andree
