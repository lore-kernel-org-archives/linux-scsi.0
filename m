From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [RFC 8/8] IB/srp: consolidate hot-path variables into cache lines
Date: Wed, 05 Jan 2011 10:13:47 -0800
Message-ID: <ada62u3fcbo.fsf@cisco.com>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov>
	<1293139893-11678-9-git-send-email-dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-3.cisco.com ([171.71.176.72]:17592 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab1AESNv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2011 13:13:51 -0500
In-Reply-To: <1293139893-11678-9-git-send-email-dillowda@ornl.gov> (David
	Dillow's message of "Thu, 23 Dec 2010 16:31:33 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>

Oh, I did have one minor comment I forgot about:

 > +	struct ib_cq	       *send_cq ____cacheline_aligned;

This could actually be ____cacheline_aligned_in_smp I think, not that it
matters at all in practice (although maybe someone will build a 1-core
embedded initiator on a memory-constrained system someday??)

 - R.
