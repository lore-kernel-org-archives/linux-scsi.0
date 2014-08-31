From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/22] scsi: Use sdev as argument for sense code printing
Date: Sun, 31 Aug 2014 14:55:38 -0700
Message-ID: <20140831215538.GA16432@infradead.org>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
 <1409247216-76074-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42514 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaHaVzk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2014 17:55:40 -0400
Content-Disposition: inline
In-Reply-To: <1409247216-76074-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

> -scsi_extd_sense_format(unsigned char asc, unsigned char ascq) {
> +scsi_extd_sense_format(unsigned char asc, unsigned char ascq,
> +		       const char **fmt) {

please move the opening brace to a new line per normal Linux style.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
