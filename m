From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 40/43] hpsa: cleanup initialization code.
Date: Mon, 23 Feb 2015 12:26:41 -0800
Message-ID: <20150223202641.GG11037@infradead.org>
References: <20150221221553.21954.32599.stgit@brunhilda>
 <20150221222105.21954.13148.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41568 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbbBWU0m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Feb 2015 15:26:42 -0500
Content-Disposition: inline
In-Reply-To: <20150221222105.21954.13148.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com, linux-scsi@vger.kernel.org

This is a backwards change.  Please keep the goto unwinding (maybe with
some better label names) instead of introducing the if allocated free pattern.
