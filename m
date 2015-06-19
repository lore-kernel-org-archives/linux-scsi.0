From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Merging se_dev_entry and se_lun?
Date: Fri, 19 Jun 2015 06:58:01 -0700
Message-ID: <20150619135801.GA20951@infradead.org>
References: <5583B957.20200@suse.de>
 <20150619065624.GA3601@infradead.org>
 <55841757.1090904@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36579 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbbFSN6D (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Fri, 19 Jun 2015 09:58:03 -0400
Content-Disposition: inline
In-Reply-To: <55841757.1090904@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

On Fri, Jun 19, 2015 at 03:21:27PM +0200, Hannes Reinecke wrote:
> > Each initiator has it's own dev entry.
> > 
> But isn't 'se_lun' per initiator, too?

No.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
