From: Tejun Heo <teheo@suse.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 16:44:07 +0200
Message-ID: <4C504237.4070105@suse.de>
References: <20100727165627.GA474@lst.de>	 <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com>	 <4C4FE58C.8080403@kernel.org> <4C4FE860.7000903@suse.de>	 <4C5036BC.30709@vlnb.net>  <4C503D50.4010006@suse.de> <1280327839.30808.188.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55444 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802Ab0G1OoK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 10:44:10 -0400
In-Reply-To: <1280327839.30808.188.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

Hello,

On 07/28/2010 04:37 PM, James Bottomley wrote:
>> I don't remember all the details now but IIRC what was necessary was
>> earlier write failure failing all commands scheduled as ordered.  Does
>> ACA / UA_INTLCK or whatever allow that?
> 
> No.  That requires support for QErr ... which is in the same mode page.

I see.

> The real reason we have difficulty is that BUSY/QUEUE_FULL can cause
> reordering in the issue queue, which is a driver problem and not in the
> SCSI standards.

Ah yeah right.  ISTR discussions about this years ago.  But one way or
the other, given the limited amount of ordering information available
under the block layer, I doubt the benefit of doing would be anything
significant.  If it can be done w/o too much complexity, sure, but
otherwise...

Thanks.

-- 
tejun
