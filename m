From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/20] scsi: consolidate opcode lookup in
 scsi_opcode_sa_name()
Date: Fri, 5 Sep 2014 17:46:54 -0700
Message-ID: <20140906004654.GB23694@infradead.org>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
 <1409738775-80876-14-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33243 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIFAq4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 20:46:56 -0400
Content-Disposition: inline
In-Reply-To: <1409738775-80876-14-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org

> +	*cdb_name = NULL;
> +	if (cmd >= 0xc0)

Can we get a START_VENDOR_SPECIFIC_CMD or similar define for 0xc0,
please?

Otherwise looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>
