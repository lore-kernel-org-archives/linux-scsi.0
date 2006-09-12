From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] cciss: version update, new hw
Date: Tue, 12 Sep 2006 07:25:07 +0200
Message-ID: <20060912052507.GF10409@kernel.dk>
References: <20060911213126.GA6867@beardog.cca.cpqcorp.net> <20060911153140.3f2433a9.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965043AbWILF0v@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060911153140.3f2433a9.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>, linux-kernel@vger.kernel.org, linux-scsi@vgter.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 11 2006, Andrew Morton wrote:
> On Mon, 11 Sep 2006 16:31:26 -0500
> "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> 
> > This patch adds support for new hardware and bumps the version to 3.6.10. It
> > seems there were several changes introduced including soft_irq. I decided
> > to bump the major number to reflect these changes. Since we're still 
> > supporting older vendor kernels I need some way differenciate between kernel
> > versions <=2.6.10 and newer kernels >=2.6.16. 
> > I hate to send this in -rc6 but it seems like 2.6.18 is having a tough time
> > getting out the gate. Please consider this for inclusion.
> 
> Adding a new device ID is a bit of a no-brainer - in fact bumping the
> version number seems more risky than adding a device ID.
> 
> I'd be OK with a 2.6.18 merge, and shall send it into Linus unless Jens
> nacks it, or gets there first.

Do just send it on for 2.6.18, it has my acked-by.

-- 
Jens Axboe
