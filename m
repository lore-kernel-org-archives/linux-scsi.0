From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] ipr: Disable async aborts
Date: Thu, 30 Oct 2014 01:17:40 -0700
Message-ID: <20141030081740.GA3194@infradead.org>
References: <201410271439.s9REdl9U017474@d01av02.pok.ibm.com>
 <1414421403.6401.5.camel@jarvis.lan>
 <20141028084716.GA14286@infradead.org>
 <54515918.4000107@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48089 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaJ3IRm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 04:17:42 -0400
Content-Disposition: inline
In-Reply-To: <54515918.4000107@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com

On Wed, Oct 29, 2014 at 04:16:08PM -0500, Brian King wrote:
> I think we can likely drop the first in the series here. I've reverted it
> and have been running abort testing for a bit and haven't hit any issues.
> Unless I see anything overnight, I'll resend the second patch by itself and
> cc stable.

Thanks, please try to find a reviewer for it as well.

