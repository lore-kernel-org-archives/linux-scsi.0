From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: blk_mq: suspicious RCU usage, rcu_read_lock() used illegally
 while idle!
Date: Fri, 7 Nov 2014 15:42:27 -0800
Message-ID: <20141107234227.GD4901@linux.vnet.ibm.com>
References: <20141106171110.GJ5718@linux.vnet.ibm.com>
 <alpine.LRH.2.11.1411071221560.9943@siim2.ut.ee>
 <20141107150628.GB4901@linux.vnet.ibm.com>
 <20141107.124558.1965251829673123349.davem@davemloft.net>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141107.124558.1965251829673123349.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, hch@infradead.org, linux-scsi@vger.kernel.org, axboe@kernel.dk, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 07, 2014 at 12:45:58PM -0500, David Miller wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Date: Fri, 7 Nov 2014 07:06:28 -0800
> 
> > On Fri, Nov 07, 2014 at 12:50:02PM +0200, Meelis Roos wrote:
> >> Perhaps DaveM can tell which one is coreect or if there is any related 
> >> problem.
> > 
> > Happy to push either of them along, if appropriate.
> 
> We should use irq_enter()/irq_exit(), and we need to also add it to
> smp_call_function_single_client().
> 
> I'll code up a final patch for sparc64 and push it upstream, thanks!

Even better!  ;-)

> Some other architectures appear to have the same problem, for example
> alpha and IA64.  Someone should grep around generic_smp_call_function*
> under arch/ and do an audit.

I will send something along in a couple days if someone else doesn't
beat me to it.  ;-)

							Thanx, Paul

