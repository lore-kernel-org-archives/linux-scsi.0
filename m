From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aic94xx: Skip reading user settings if flash is not found
Date: Thu, 27 Aug 2015 00:43:57 -0700
Message-ID: <20150827074357.GA14869@infradead.org>
References: <1436180878-81565-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45600 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbbH0HoE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2015 03:44:04 -0400
Content-Disposition: inline
In-Reply-To: <1436180878-81565-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, Jul 06, 2015 at 01:07:58PM +0200, Hannes Reinecke wrote:
> If no user settings are found it's pointless trying to
> read them from flash. So skip that step.
> This also fixes a compilation warning about uninitialized variables in
> aic94xx.

This looks okay to me.

Reviewed-by: Christoph Hellwig <hch@lst.de>
