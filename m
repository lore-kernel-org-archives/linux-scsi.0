From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 28/48] hpsa: use per-controller work queue
Date: Thu, 15 Jan 2015 03:32:40 -0800
Message-ID: <20150115113240.GA9613@infradead.org>
References: <20150114215756.21325.41198.stgit@brunhilda>
 <20150114220205.21325.5519.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60548 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbbAOLcn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2015 06:32:43 -0500
Content-Disposition: inline
In-Reply-To: <20150114220205.21325.5519.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com, linux-scsi@vger.kernel.org

This should be folded into the previous patch.
