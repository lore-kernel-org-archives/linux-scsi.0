From: Matthew Jacob <mjacob@feral.com>
Subject: Re: Warning - running *really* short on DMA buffers while doing file
 transfers
Date: Fri, 27 Sep 2002 08:34:25 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0209270833450.21876-100000@beppo>
References: <389902704.1033133455@aslan.scsiguy.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <389902704.1033133455@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Jens Axboe <axboe@suse.de>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


> If you don't like this behavior, which actually maximizes the
> throughput of the device, have the I/O scheduler hold back a single
> processes from creating such a large backlog.


Justin and I are (for once) in 100% agreement.


