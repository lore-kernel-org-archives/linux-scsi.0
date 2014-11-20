From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Wed, 19 Nov 2014 22:01:35 -0800
Message-ID: <20141120060135.GA2862@infradead.org>
References: <alpine.LRH.2.11.1411141302270.26966@adalberg.ut.ee>
 <20141114165804.GA14631@infradead.org>
 <alpine.LRH.2.11.1411142114200.26813@adalberg.ut.ee>
 <54665B30.4070708@kernel.dk>
 <alpine.LRH.2.11.1411150033400.26813@adalberg.ut.ee>
 <54669063.6050307@kernel.dk>
 <alpine.LRH.2.11.1411150829190.26813@adalberg.ut.ee>
 <546771B4.1010507@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <546771B4.1010507@kernel.dk>
Sender: sparclinux-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Meelis Roos <mroos@linux.ee>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Nov 15, 2014 at 08:31:00AM -0700, Jens Axboe wrote:
> My next move would be to add more debug to the CPU map setup and teardown,
> so that we can verify that the map that is being used above has indeed been
> setup. Unless Christoph has any ideas on what is going on here?

No good idea, but I'd sugges to debug cpu_to_queue_index how it could
return such an out of bounds value.
