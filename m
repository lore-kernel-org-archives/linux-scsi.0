From: Matthew Jacob <mjacob@feral.com>
Subject: Re: Warning - running *really* short on DMA buffers while doing file
 transfers
Date: Thu, 26 Sep 2002 23:33:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0209262333050.17672-100000@beppo>
References: <20020927061328.GL5646@suse.de>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020927061328.GL5646@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


> 2.4 layer is most horrible there, 2.5 at least gets rid of the old
> scsi_dma crap. That said, 253 default depth is a bit over the top, no?

Why? Something like a large Hitachi 9*** storage system can take ~1000
tags w/o wincing.


