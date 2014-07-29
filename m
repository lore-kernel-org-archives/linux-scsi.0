From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] sd: Optionally attach to ZBC devices
Date: Tue, 29 Jul 2014 10:14:14 -0700
Message-ID: <20140729171414.GA1060@infradead.org>
References: <1406645117-53088-1-git-send-email-hare@suse.de>
 <1406645117-53088-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35177 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaG2ROP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jul 2014 13:14:15 -0400
Content-Disposition: inline
In-Reply-To: <1406645117-53088-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hsh@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Tue, Jul 29, 2014 at 04:45:17PM +0200, Hannes Reinecke wrote:
> ZBC drives are close to disk devices, so sd.c is well
> suited as a testbed for ZBC devices.
> This patch introduces a module option 'attach_zbc' to
> sd which will make the sd driver accept ZBC
> devices as normal disk drives.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks reasonable to me.

I'd also really like a sysfs file that tells us if we're dealing
with a host aware device, as those report as TYPE_SBC. 

