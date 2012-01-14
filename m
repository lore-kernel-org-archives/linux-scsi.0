From: David Dillow <dillowda@ornl.gov>
Subject: Re: [PATCH 00/18, v2] Make ib_srp better suited for H.A. purposes
Date: Sat, 14 Jan 2012 17:10:12 -0500
Message-ID: <1326579013.8227.4.camel@obelisk.thedillows.org>
References: <3109536.qySrY1Ts3e@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:42471 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab2ANWKZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jan 2012 17:10:25 -0500
In-Reply-To: <3109536.qySrY1Ts3e@asus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>, Vu Pham <vuhuong@mellanox.com>

On Sat, 2012-01-14 at 12:36 +0000, Bart Van Assche wrote:
> This patch series makes the ib_srp driver better suited for use in a H.A.

What kernel version is this based on?

Patch 17 (srp_transport: Add transport layer recovery support) doesn't
apply with 'git am'. I haven't investigated why yet, so it may be quite
simple.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

