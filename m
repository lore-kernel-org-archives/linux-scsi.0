From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aic94xx: Fixup compilation warning
Date: Wed, 5 Nov 2014 22:37:55 -0800
Message-ID: <20141106063755.GA26433@infradead.org>
References: <1415085059-127936-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53010 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaKFGh6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 01:37:58 -0500
Content-Disposition: inline
In-Reply-To: <1415085059-127936-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Tue, Nov 04, 2014 at 08:10:59AM +0100, Hannes Reinecke wrote:
> gcc complained about an uninitialized warning.

Looks fine to me, although it very much is gcc overreacting.

