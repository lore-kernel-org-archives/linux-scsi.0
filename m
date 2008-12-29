From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -next v2] cxgb3i: use same dependencies & selects as	CHELSIO_T3
Date: Mon, 29 Dec 2008 14:08:13 -0800
Message-ID: <49594A4D.6050303@oracle.com>
References: <20081230031621.60acd90b.sfr@canb.auug.org.au>	 <20081229130110.67d5271a.randy.dunlap@oracle.com>	 <20081229132312.10934479.randy.dunlap@oracle.com> <1230587887.3302.70.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:32743 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbYL2WJI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Dec 2008 17:09:08 -0500
In-Reply-To: <1230587887.3302.70.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, scsi <linux-scsi@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, kxie@chelsio.com, akpm <akpm@linux-foundation.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, samr <sam@ravnborg.org>

James Bottomley wrote:
> On Mon, 2008-12-29 at 13:23 -0800, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Make the CXGB iSCSI driver (that selects the CXGB net driver) have the same
>> dependencies as the net driver, since kconfig doesn't do that automatically.
>> Also make it select INET_LRO & FW_LOADER like the net driver does.
> 
> I thought select of a symbol that selected something else propagated
> correctly (even if select of a symbol that depends on something else
> doesn't).

I don't see that happening, at least in this case.
Sam, can you clarify?


> If this is untrue, we have several other Kconfig problems in
> the kernel.

That would not be a surprise.

-- 
~Randy
