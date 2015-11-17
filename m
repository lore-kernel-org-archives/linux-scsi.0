From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH for-next 05/10] iser: Have initiator and target to share
 protocol structures and definitions
Date: Tue, 17 Nov 2015 00:59:33 -0800
Message-ID: <20151117085933.GC19578@infradead.org>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-6-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36582 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbbKQI7d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2015 03:59:33 -0500
Content-Disposition: inline
In-Reply-To: <1447691861-3796-6-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Steve Wise <swise@opengridcomputing.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Nov 16, 2015 at 06:37:36PM +0200, Sagi Grimberg wrote:
> The iser RDMA_CM negotiation protocol is shared by
> the initiator and the target, so have a shared header
> for the defines and structure. Move relevant items from
> the initiator and target headers.

Nice!

But should a header that just documents protocol constants really
have a copyright header?
