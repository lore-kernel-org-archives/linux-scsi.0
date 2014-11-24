From: David Miller <davem@davemloft.net>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Mon, 24 Nov 2014 17:28:57 -0500 (EST)
Message-ID: <20141124.172857.1186013178918344826.davem@davemloft.net>
References: <20141124162249.GG5050@linux.vnet.ibm.com>
	<547367DF.5060706@kernel.dk>
	<alpine.LRH.2.11.1411250022470.31497@siim2.ut.ee>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:54535 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaKXW3B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 17:29:01 -0500
In-Reply-To: <alpine.LRH.2.11.1411250022470.31497@siim2.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mroos@linux.ee
Cc: axboe@kernel.dk, paulmck@linux.vnet.ibm.com, hch@infradead.org, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org

From: mroos@linux.ee
Date: Tue, 25 Nov 2014 00:23:20 +0200 (EET)

>> > > > Yes, that does look like the case.  Do you have a good trick on how
>> > > > to allocate a map for the highest possible cpu number without first
>> > > > iterating the cpu map?  I couldn't find something that looks like a
>> > > > highest_possible_cpu() helper.
>> > >
>> > > Honestly I think that num_posible_cpus() should return the max of
>> > > number of CPUs (weigt), and the highest numbered CPU. It's a pain in
>> > > the butt to handle this otherwise.
>> >
>> > Hear, hear!!!  That would make my life easier, and would make this sort
>> > of problem much less likely to occur!
>> 
>> How about this one?
> 
> It make the machine work.

Thanks for testing!
