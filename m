From: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in blk_recalc_rq_segments
Date: Thu, 24 Jul 2008 22:40:08 -0400 (EDT)
Message-ID: <20080725024009.82A4C4DCB@hiauly1.hia.nrc.ca>
References: <Pine.LNX.4.64.0807241727320.12036@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0807241727320.12036@devserv.devel.redhat.com> from "Mikulas Patocka" at Jul 24, 2008 05:49:14 pm
Sender: linux-parisc-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: James.Bottomley@HansenPartnership.com, davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> * it is only used on two architectures, one already outdated (alpha), the 
> other being discontinued (pa-risc). On all the other architectures, 
> hw_segments == phys_segments

This "business based" argument should be ignored.  Followed to the limit,
there would only be one architecture left...

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
