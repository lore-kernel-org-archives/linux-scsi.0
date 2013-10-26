From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 03/10] scsi_transport_srp: Add transport layer error handling
Date: Sat, 26 Oct 2013 08:30:27 +0200
Message-ID: <526B6183.3040601@acm.org>
References: <52569806.9080201@acm.org> <525699A9.6090802@acm.org>	 <5262AF8D.7070700@acm.org> <1382740925.17280.6.camel@frustration.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yahoo.smtp.stone-is.be ([5.134.1.31]:37685 "EHLO
	yahoo.smtp.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab3JZGad (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Oct 2013 02:30:33 -0400
In-Reply-To: <1382740925.17280.6.camel@frustration.ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: Roland Dreier <roland@kernel.org>, Vu Pham <vu@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>

On 10/26/13 00:42, David Dillow wrote:
> On Sat, 2013-10-19 at 18:13 +0200, Bart Van Assche wrote:
>> Since it takes some work to figure out the state transitions from the
>> source code, I have tried to draw a diagram representing all state
>> transitions. I have attached that diagram to this e-mail. That diagram
>> probably will make it easier to review this code.
>
> This is handy, Bart -- could you put it in a patch? I suppose it belongs
> under Documentation/infiniband...

Hello Dave,

That sounds like a good idea to me. I will post such a patch as soon as 
possible - the coming two weeks I will be traveling.

Bart.

