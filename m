From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] remove cpqarray from mainline kernel
Date: Thu, 17 Oct 2013 16:36:16 -0600
Message-ID: <20131017223616.GB32575@kernel.dk>
References: <20131017175226.GA31535@thumper.usa.hp.com>
 <20131017141337.425f84c630ffe1c7c61c4dc4@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131017141337.425f84c630ffe1c7c61c4dc4@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Miller <mike.miller@hp.com>, LKML-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 17 2013, Andrew Morton wrote:
> On Thu, 17 Oct 2013 12:52:26 -0500 Mike Miller <mike.miller@hp.com> wrote:
> 
> > cpqarray hasn't been used in over 12 years. It's doubtful that anyone still
> > uses the board. It's time the driver was removed from the mainline kernel.
> > The only updates these days are minor and mostly done by people outside of HP.
> 
> It's amazing the weird stuff people get up to.  Perhaps we should disable
> it in config for a cycle or two, see if that flushes anyone out?

I think that would be prudent, you never know what people run...

-- 
Jens Axboe
