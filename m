From: Fabien Salvi <fabien@cri74.org>
Subject: Re: SCSI Disk layer performance
Date: Fri, 23 Jan 2004 12:02:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4010FF56.2060806@cri74.org>
References: <1074720667.19927.384.camel@localhost.lnxi.com> <20040122135703.A11283@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aravis.cur-archamps.fr ([195.202.0.99]:61887 "EHLO
	aravis.cur-archamps.fr") by vger.kernel.org with ESMTP
	id S266552AbUAWLCt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2004 06:02:49 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org



Christoph Hellwig a e'crit:
> On Wed, Jan 21, 2004 at 02:31:08PM -0700, Chris Worley wrote:
> 
>>My FC array seems to be faster than Linux can handle.
>>
>>Even though I'm using FC-2 cards, Linux seems to put
>>an artificial limit at FC-1 speeds.  This is true in two cases:
> 
> 
> What kernel tree do you use?  If you're looking for decent scsi
> performance use linux 2.6 or the SuSE/RH vendor trees.  Stock Linux 2.4
> is basically unusable for higher scsi loads in SMP enviroments.

Can you give more details about this ?

Instead of using vendor trees, is it possible to use specific and 
validated patchs about this ?

vendors trees are awfully patched and difficult to maintain/upgrade for 
customers...

-- 
Fabien S

