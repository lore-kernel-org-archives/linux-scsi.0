From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 19/22] advansys: Remove comment around cmd_per_lun
Date: Fri, 24 Apr 2015 02:41:03 -0700
Message-ID: <20150424094103.GA23248@infradead.org>
References: <1429864377-67002-1-git-send-email-hare@suse.de>
 <1429864377-67002-20-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55592 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965828AbbDXJlQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2015 05:41:16 -0400
Content-Disposition: inline
In-Reply-To: <1429864377-67002-20-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On Fri, Apr 24, 2015 at 10:32:54AM +0200, Hannes Reinecke wrote:
> Ancient, and pretty much obsolete by now.

And still doesn't address the fixme.  You probably should remove the
cmd_per_lun setting entirely.
