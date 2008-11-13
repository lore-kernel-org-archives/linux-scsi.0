From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 03/18 ver3] libosd: OSDv1 Headers
Date: Thu, 13 Nov 2008 11:38:43 +0200
Message-ID: <491BF5A3.9070700@panasas.com>
References: <491073BB.4000900@panasas.com>	<1225817046-5946-1-git-send-email-bharrosh@panasas.com>	<4916F934.4090205@panasas.com>	<20081110092940.57b4c169.randy.dunlap@oracle.com>	<491AD697.9030305@panasas.com> <20081112105945.f4ec0089.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:23689 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750728AbYKMJi2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2008 04:38:28 -0500
In-Reply-To: <20081112105945.f4ec0089.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, open-osd development <osd-dev@open-osd.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sami.Iren@seagate.com, linux-kernel <linux-kernel@vger.kernel.org>

Randy Dunlap wrote:
> 
> ugh
> 
>> +		} __packed attrs_cdb;
>> +/*52*/		u8 get_set_attributes_parameters[80-52];
> 
> ugh
> 
> 
> more of the same
> 
> 
> ditto.  nice comment ;)
> 
> 
> 
> Thanks for the fixes.
> 

Yes Yes that was version 3 where I was asking if I might convince you
for its merits.

As I said in that reply I will change it. Just did not have the chance
to send out version 4 out yet.

Thanks
Boaz
