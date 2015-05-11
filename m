From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/17] scsi: remove scsi_show_sense_hdr()
Date: Mon, 11 May 2015 08:49:39 +0200
Message-ID: <20150511064939.GD30516@lst.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38974 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbbEKGtl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 02:49:41 -0400
Content-Disposition: inline
In-Reply-To: <1430743343-47174-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, May 04, 2015 at 02:42:11PM +0200, Hannes Reinecke wrote:
> Last caller is gone, so remove it.

And the implementation as well is gone as well..  Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
