From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: arm: fas216: Use %llu to print 'u64' format
Date: Thu, 10 Jul 2014 23:23:02 -0700
Message-ID: <20140711062302.GA12385@infradead.org>
References: <1405035187-27737-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58055 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbaGKGXE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jul 2014 02:23:04 -0400
Content-Disposition: inline
In-Reply-To: <1405035187-27737-1-git-send-email-festevam@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fabio Estevam <festevam@gmail.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>

Thanks Fabio,

this looks good to me.  Are there any other warnings you got from that
autobuilder?

