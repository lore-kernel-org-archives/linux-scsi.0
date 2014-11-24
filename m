From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Mon, 24 Nov 2014 15:20:29 -0700
Message-ID: <5473AF2D.7090905@kernel.dk>
References: <547367DF.5060706@kernel.dk>	<20141124.165623.42259031853400756.davem@davemloft.net>	<5473AAD3.7010409@kernel.dk> <20141124.170933.410328396352735176.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20141124.170933.410328396352735176.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: paulmck@linux.vnet.ibm.com, hch@infradead.org, mroos@linux.ee, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/24/2014 03:09 PM, David Miller wrote:
> From: Jens Axboe <axboe@kernel.dk>
> Date: Mon, 24 Nov 2014 15:01:55 -0700
>
>> I'll just updated blk-mq to use nr_cpu_ids and be done with it.
>
> Wow, a grep on nr_cpu_ids gets a lot of hits on people allocating just
> these kinds of tables :)

Yep! It'd be nicer to export a helper for that, I bet it's just one of 
those things that people started using because it's there and there are 
no functions for getting this information.

-- 
Jens Axboe

