From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] bnx2fc: fix incorrect DMA memory mapping in
 bnx2fc_map_sg()
Date: Tue, 19 Aug 2014 12:09:10 -0500
Message-ID: <20140819170910.GA12221@infradead.org>
References: <1407140413-4561-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41327 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbaHSRHA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Aug 2014 13:07:00 -0400
Content-Disposition: inline
In-Reply-To: <1407140413-4561-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: QLogic-Storage-Upstream@qlogic.com, eddie.wai@broadcom.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com

Can I get a review for this one, please?

