From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ipr: Disable async aborts
Date: Wed, 29 Oct 2014 16:16:08 -0500
Message-ID: <54515918.4000107@linux.vnet.ibm.com>
References: <201410271439.s9REdl9U017474@d01av02.pok.ibm.com> <1414421403.6401.5.camel@jarvis.lan> <20141028084716.GA14286@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:37051 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089AbaJ2VQP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2014 17:16:15 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 29 Oct 2014 15:16:15 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 5AB2319D8042
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2014 15:04:55 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s9TLGC0452691194
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2014 22:16:12 +0100
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s9TLGBRA021790
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2014 15:16:12 -0600
In-Reply-To: <20141028084716.GA14286@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com

On 10/28/2014 03:47 AM, Christoph Hellwig wrote:
> On Mon, Oct 27, 2014 at 07:50:03AM -0700, James Bottomley wrote:
>> On Mon, 2014-10-27 at 09:37 -0500, Brian King wrote:
>>> The ipr driver does not yet support async aborts, so disable this
>>> for now.
>>>
>>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>>
>> By "does not yet support" do you mean doesn't work with or merely not
>> tested with but seems to work OK?  if the former, then surely this
>> should be a fixes patch with a cc to stable for all the kernels async
>> abort is in (which is 3.14)
> 
> I'm pretty sure this patch is incorrect, and that what ever issue should
> have been described in this patch are the same EH problems we fixed in
> the last couple releases.  I've also talked to Hannes a while ago, and
> we agree that we want to remove this flag ASAP as it's inviting this

I think we can likely drop the first in the series here. I've reverted it
and have been running abort testing for a bit and haven't hit any issues.
Unless I see anything overnight, I'll resend the second patch by itself and
cc stable.

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


