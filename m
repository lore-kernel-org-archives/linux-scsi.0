From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc requests and
 simplify hw handlers
Date: Wed, 08 Jun 2005 10:41:48 -0500
Message-ID: <42A711BC.9020108@cs.wisc.edu>
References: <1117847972.23638.62.camel@mina> <1117901234.5005.9.camel@mulgrave> <1117955727.4961.8.camel@mina> <20050606190205.GA6817@us.ibm.com> <1118157976.42a5bc98d6f75@webmail.cs.wisc.edu> <20050607182317.GA12959@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55472 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262004AbVFHVnS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2005 17:43:18 -0400
In-Reply-To: <20050607182317.GA12959@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

Patrick Mansfield wrote:
> On Tue, Jun 07, 2005 at 10:26:16AM -0500, Michael Christie wrote:
> 
>>Quoting Patrick Mansfield <patmans@us.ibm.com>:
> 
> 
>>>Why can't the retries be passed down via a new blk req->retries?
>>>
>>
>>Is that all that is needed for dm-multipath? I thought this would be a good time
>>to add some code to allow the finer grained control of retries that could also
>>be used by dm and md. For example do you only want to retry certain failures X
>>numbeer of times?
> 
> 
> I was looking/thinking about the scsi_scan retries not multipath.

And I was hoping the same code/framework can be used for scsi, DM, MD, 
SG_IO and all other block layer drivers.
