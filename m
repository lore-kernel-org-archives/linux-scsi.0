From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] SAS transport class
Date: Tue, 06 Sep 2005 18:00:00 +0200
Message-ID: <431DBD00.2060309@s5r6.in-berlin.de>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A75@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:8681 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750735AbVIFP7O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Sep 2005 11:59:14 -0400
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A75@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com, hch@lst.de

James Smart wrote:
> I'll point out, but not delve into - that you've avoided the target
> id bindings again, thus forcing the lldd's/adapters to maintain tables
> of port#/SASaddr to target id (if they care, and I believe enterprise
> storage will care!).  I can understand if you're going to eventually
> insert a generic abstraction layer for scsi's b/c/t/l addressing
> scheme, but since it's not here today, I expect you to hold SAS to the
> same "code sharing" level as FC.

b/c/t/l has no place in layers below scsi core (except in SPI low-level 
where it has actual meaning).

I don't understand exactly what should be accomplished by a table of 
WWNs to target IDs --- but any kind of mapping between WWN and device 
file (and thereby between WWN and a faked b/c/t/l) belongs into 
userspace, not into the kernel.

Furthermore, there cannot be an "abstraction layer for scsi's b/c/t/l 
addressing scheme". It is impossible to abstract something which is 
without meaning.
-- 
Stefan Richter
-=====-=-=-= =--= --==-
http://arcgraph.de/sr/
