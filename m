From: Jens Axboe <axboe@suse.de>
Subject: Re: Warning - running *really* short on DMA buffers while doing file transfers
Date: Fri, 27 Sep 2002 08:36:16 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20020927063616.GO5646@suse.de>
References: <20020927061328.GL5646@suse.de> <Pine.BSF.4.21.0209262333050.17672-100000@beppo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.BSF.4.21.0209262333050.17672-100000@beppo>
To: Matthew Jacob <mjacob@feral.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 26 2002, Matthew Jacob wrote:
> 
> > 2.4 layer is most horrible there, 2.5 at least gets rid of the old
> > scsi_dma crap. That said, 253 default depth is a bit over the top, no?
> 
> Why? Something like a large Hitachi 9*** storage system can take ~1000
> tags w/o wincing.

Yeah, I bet that most of the devices attached to aic7xxx controllers are
exactly such beasts.

I didn't say that 253 is a silly default for _everything_, I think it's
a silly default for most users.

-- 
Jens Axboe
