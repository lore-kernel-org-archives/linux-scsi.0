From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 20/22] scsi: align logging messages
Date: Sun, 31 Aug 2014 15:25:56 -0700
Message-ID: <20140831222556.GL16432@infradead.org>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
 <1409247216-76074-21-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48602 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaHaWZ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2014 18:25:58 -0400
Content-Disposition: inline
In-Reply-To: <1409247216-76074-21-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On Thu, Aug 28, 2014 at 07:33:34PM +0200, Hannes Reinecke wrote:
> Always use 'scmd 0x%p' when logging a command pointer.

Is there any good reason to print the address of a command pointer?

