From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Warning - running *really* short on DMA buffers while
 doingfiletransfers
Date: Fri, 27 Sep 2002 15:29:36 -0600
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <2646716224.1033162176@aslan.btc.adaptec.com>
References: <200209272123.g8RLNAi21161@localhost.localdomain>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <200209272123.g8RLNAi21161@localhost.localdomain>
Content-Disposition: inline
To: James Bottomley <James.Bottomley@steeleye.com>, mjacob@feral.com
Cc: Andrew Morton <akpm@digeo.com>, Jens Axboe <axboe@suse.de>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> That was true of 2.2, 2.3 (and I think early 2.4) but it isn't true of
> late  2.4 and 2.5

I have see 0 changes in 2.4 that indicate that it is safe to have the
mid-layer do queuing.

--
Justin
