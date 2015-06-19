From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Merging se_dev_entry and se_lun?
Date: Thu, 18 Jun 2015 23:56:24 -0700
Message-ID: <20150619065624.GA3601@infradead.org>
References: <5583B957.20200@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58893 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbbFSG42 (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Fri, 19 Jun 2015 02:56:28 -0400
Content-Disposition: inline
In-Reply-To: <5583B957.20200@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

On Fri, Jun 19, 2015 at 08:40:23AM +0200, Hannes Reinecke wrote:
> Having a list here implies that 'se_lun' can have _several_
> se_dev_entry structure attached to it, which I found rather curious.
> 
> Can you give me an example where this might be the case?
> Or can we replace the list with a simple pointer or even merge both?

Each initiator has it's own dev entry.

What might make sense with the new list-based dev entry handling is to
merge the se_lun_acl and se_dev_entry, but it would be a fair amount of
work.
