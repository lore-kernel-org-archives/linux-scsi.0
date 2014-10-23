From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix off-by-one LUN check in scsi_scan_host_selected()
Date: Thu, 23 Oct 2014 10:13:06 -0700
Message-ID: <20141023171306.GE16015@infradead.org>
References: <20141009123948.ed14b2f96456fecdb4af960b@clara.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38889 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaJWRNG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Oct 2014 13:13:06 -0400
Content-Disposition: inline
In-Reply-To: <20141009123948.ed14b2f96456fecdb4af960b@clara.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Knibbs <markk@clara.co.uk>
Cc: linux-scsi@vger.kernel.org

Thanks,

applied to the core-for-3.19 branch.
