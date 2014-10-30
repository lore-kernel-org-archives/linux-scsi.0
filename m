From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ipr: Convert to generic DMA API
Date: Thu, 30 Oct 2014 08:40:52 -0500
Message-ID: <54523FE4.5040503@linux.vnet.ibm.com>
References: <1413191676-1663-1-git-send-email-anton@samba.org> <54512539.5040501@linux.vnet.ibm.com> <20141030091153.GA18224@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:42304 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759470AbaJ3Nk7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 09:40:59 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 30 Oct 2014 07:40:58 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 9E19919D8039
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2014 07:29:37 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s9UDethx49545448
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2014 14:40:55 +0100
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s9UDeriU016232
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2014 07:40:54 -0600
In-Reply-To: <20141030091153.GA18224@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Anton Blanchard <anton@samba.org>, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, wenxiong@linux.vnet.ibm.com, scottwood@freescale.com, linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org

On 10/30/2014 04:11 AM, Christoph Hellwig wrote:
> On Wed, Oct 29, 2014 at 12:34:49PM -0500, Brian King wrote:
>> Acked-by: Brian King <brking@linux.vnet.ibm.com>
> 
> Doesn't apply to me.
> 
> Brain, can you please resend a rebased version of these two patches with
> ipr error handlign patch (and anything else ipr related)?
> 

Sorry. Let me rebase on top of your tree...

-Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


