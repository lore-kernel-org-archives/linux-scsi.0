From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 38/43] hpsa: clean up new block layer tag error handling
Date: Mon, 23 Feb 2015 12:25:50 -0800
Message-ID: <20150223202550.GF11037@infradead.org>
References: <20150221221553.21954.32599.stgit@brunhilda>
 <20150221222055.21954.2960.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41194 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbbBWUZv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Feb 2015 15:25:51 -0500
Content-Disposition: inline
In-Reply-To: <20150221222055.21954.2960.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com, linux-scsi@vger.kernel.org

This needs to be folded into the previous patch.
