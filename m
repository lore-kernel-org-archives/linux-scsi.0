From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 1/1] block: blk-merge: don't merge the pages with
	non-contiguous descriptors
Date: Thu, 17 Jan 2013 11:04:38 +0000
Message-ID: <20130117110438.GZ23505@n2100.arm.linux.org.uk>
References: <1358265681-25671-1-git-send-email-subhashj@codeaurora.org> <1358266794.10591.8.camel@dabdike.int.hansenpartnership.com> <50F64AC1.3040304@codeaurora.org> <1358332355.2384.11.camel@dabdike.int.hansenpartnership.com> <20130116231857.GU2668@htj.dyndns.org> <1358413880.2394.7.camel@dabdike.int.hansenpartnership.com> <20130117103742.GX23505@n2100.arm.linux.org.uk> <20130117104741.GY23505@n2100.arm.linux.org.uk> <1358420507.2394.19.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48518 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3AQLEv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2013 06:04:51 -0500
Content-Disposition: inline
In-Reply-To: <1358420507.2394.19.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Tejun Heo <tj@kernel.org>, asias@redhat.com, linux-arm-kernel@lists.infradead.org

On Thu, Jan 17, 2013 at 11:01:47AM +0000, James Bottomley wrote:
> On Thu, 2013-01-17 at 10:47 +0000, Russell King - ARM Linux wrote:
> > Also, couldn't the addition of the scatterlist offset to the page also
> > be buggy too?
> 
> No, fortunately, offset must be within the first page from the point of
> view of block generated sg lists.  As long as nothing within arm
> violates this, it should be a safe assumption ... although the code
> seems to assume otherwise.

Are you absolutely sure about that?  I believe I have seen cases where
that has been violated in the past, though it was many years ago.
