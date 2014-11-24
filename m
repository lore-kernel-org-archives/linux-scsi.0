From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Mon, 24 Nov 2014 00:21:32 -0800
Message-ID: <20141124082132.GA22971@infradead.org>
References: <alpine.LRH.2.11.1411150829190.26813@adalberg.ut.ee>
 <546771B4.1010507@kernel.dk>
 <20141120060135.GA2862@infradead.org>
 <20141121.145600.2001813891553289235.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141121.145600.2001813891553289235.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, axboe@kernel.dk, mroos@linux.ee, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, paulmck@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 21, 2014 at 02:56:00PM -0500, David Miller wrote:
> I would suggest looking into the possibility that we allocate the memory
> using the count of valid cpus, rather than the largest cpu number.
> 
> That's a common error that runs into problems with discontiguous
> cpu numbering like Sparc sometimes has.

Yes, that does look like the case.  Do you have a good trick on how
to allocate a map for the highest possible cpu number without first
iterating the cpu map?  I couldn't find something that looks like a
highest_possible_cpu() helper.
