From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] libata: Implement ATA_DEV_ZAC
Date: Mon, 2 Jun 2014 02:17:45 -0700
Message-ID: <20140602091745.GB32301@infradead.org>
References: <1401692478-23557-1-git-send-email-hare@suse.de>
 <1401692478-23557-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39066 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaFBJRu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 05:17:50 -0400
Content-Disposition: inline
In-Reply-To: <1401692478-23557-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

This also need to be run past the libata maintainers and the linux-ide
list..

> +	if ((lbam == 0xcd) && (lbah == 0xab)) {

The inner braces here aren't needed.

