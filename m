From: David Dillow <dillowda@ornl.gov>
Subject: Re: [PATCH 0/3] SCSI SRP transport layer patches for kernel 3.14
Date: Mon, 30 Dec 2013 16:46:43 -0500
Message-ID: <1388440003.22718.19.camel@frustration.ornl.gov>
References: <52A88CF9.206@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta01.ornl.gov ([128.219.177.14]:10021 "EHLO mta01.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222Ab3L3V40 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Dec 2013 16:56:26 -0500
In-Reply-To: <52A88CF9.206@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Vu Pham <vu@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, James Bottomley <JBottomley@Parallels.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2013-12-11 at 17:04 +0100, Bart Van Assche wrote:
> This series of three patches is what I came up with after several weeks
> of path failover testing of the 3.13-rc1 IB/SRP initiator on a large
> setup. The patches in this series are:
> * Make SRP transport layer behavior more consistent with that of the FC
>   transport layer.
> * Fix a rare race condition triggered by path failover.
> * Document the rport state transitions.

For all three,

Acked-by: David Dillow <dillowda@ornl.gov>

Thanks Bart!

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

