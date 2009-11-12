From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Crash during SATA reads
Date: Thu, 12 Nov 2009 11:12:58 +0100
Message-ID: <20091112101257.GG8742@kernel.dk>
References: <bd36f99e0911110118v6dc7f87ao98968ba234fad7fc@mail.gmail.com> <4AFA835B.9000904@garzik.org> <bd36f99e0911110412hf2c7920gf06bd29ed43e240c@mail.gmail.com> <bd36f99e0911111309ie8166a9h8f926948bf15d350@mail.gmail.com> <4AFB2F2A.7080900@garzik.org> <20091112091602.GC8742@kernel.dk> <bd36f99e0911120148t43a267cbwd1899d3e68468cc@mail.gmail.com> <20091112095544.GF8742@kernel.dk> <bd36f99e0911120211h2bda5062qe90d7be56203523@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752278AbZKLKMy@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bd36f99e0911120211h2bda5062qe90d7be56203523@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Glenn Maynard <glenn@zewt.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 12 2009, Glenn Maynard wrote:
> On Thu, Nov 12, 2009 at 4:55 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > To rule out any potential hardware problems, have you run any extensive
> > memory checks on this machine?
> 
> God damn it.  I ran memtest+ just a week or so ago and it was fine
> through several passes; now it's failing badly.  I'm inclined to send
> Kingston a bill for a day and a half of wasted time.

Auch, perhaps it's just seated badly? Power problems? Or yes, you just
got crap RAM :/

> I didn't think back to memory since I'm used to memory problems in
> userspace, where they cause wildly variable crashes.  Of course, the
> kernel's far more likely to stick data in the same spot, so it makes
> sense that it doesn't cause as much volatility, leading to a bunch of
> related-looking crashes.

Well, at least it's a relief that it isn't a kernel issue :-)

-- 
Jens Axboe
