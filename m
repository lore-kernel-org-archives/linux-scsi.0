From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] blk-timeout: add BLK_EH_SCHEDULED return code
Date: Wed, 30 Oct 2013 01:43:03 -0700
Message-ID: <20131030084303.GA3772@infradead.org>
References: <1383122272-93572-1-git-send-email-hare@suse.de>
 <1383122272-93572-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46115 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab3J3InI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2013 04:43:08 -0400
Content-Disposition: inline
In-Reply-To: <1383122272-93572-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

On Wed, Oct 30, 2013 at 09:37:50AM +0100, Hannes Reinecke wrote:
> Add a 'BLK_EH_SCHEDULED' return code for blk-timeout to indicate
> that a delayed error recovery has been initiated.

The user introduces here gets immediately reverted in the next patch,
which means this patch can simply be dropped.

