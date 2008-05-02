From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
Date: Fri, 2 May 2008 11:33:06 -0400
Message-ID: <20080502153306.GB7376@infradead.org>
References: <200805021638.42972.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40408 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759180AbYEBPdJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 11:33:09 -0400
Content-Disposition: inline
In-Reply-To: <200805021638.42972.bart.vanassche@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel@lists.sourceforge.net

NACK.

First scsi_execute_async has a horrible API and thus it's on it's way
out, no way we'll add another variant of it.

Second we're not going to add things to the core just for out of tree
modules.

