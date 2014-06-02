From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fc: ensure scan_work isn't active when freeing fc_rport
Date: Mon, 2 Jun 2014 01:35:04 -0700
Message-ID: <20140602083504.GA22961@infradead.org>
References: <1401461974-7879-1-git-send-email-nhorman@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44056 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaFBIfN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 04:35:13 -0400
Content-Disposition: inline
In-Reply-To: <1401461974-7879-1-git-send-email-nhorman@tuxdriver.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Cc: fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, Robert Love <robert.w.love@intel.com>, Vasu Dev <vasu.dev@intel.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
