From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Warning - running *really* short on DMA buffers while
 doingfiletransfers
Date: Fri, 27 Sep 2002 17:23:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209272123.g8RLNAi21161@localhost.localdomain>
References: <mjacob@feral.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA23721
	for <linux-scsi@vger.kernel.org>; Fri, 27 Sep 2002 14:23:19 -0700
In-Reply-To: Message from Matthew Jacob <mjacob@feral.com>
   of "Fri, 27 Sep 2002 14:18:12 PDT." <Pine.BSF.4.21.0209271417260.22542-100000@beppo>
List-Id: linux-scsi@vger.kernel.org
To: mjacob@feral.com
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Andrew Morton <akpm@digeo.com>, Jens Axboe <axboe@suse.de>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

mjacob@feral.com said:
> Duh. There had been race conditions in the past which caused all of us
> HBA writers to in fact start swalloing things like QFULL and
> maintaining internal queues. 

That was true of 2.2, 2.3 (and I think early 2.4) but it isn't true of late 
2.4 and 2.5

James


