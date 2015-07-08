From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 5/5] target: Fix wrong setting of sense format for PI
 errors
Date: Wed, 8 Jul 2015 03:49:55 -0700
Message-ID: <20150708104955.GA20842@infradead.org>
References: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
 <1436188508-1539-6-git-send-email-sagig@mellanox.com>
 <20150708101931.GD14466@infradead.org>
 <559CFD14.9090803@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42879 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263AbbGHKt6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2015 06:49:58 -0400
Content-Disposition: inline
In-Reply-To: <559CFD14.9090803@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Sagi Grimberg <sagig@mellanox.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>

On Wed, Jul 08, 2015 at 01:36:04PM +0300, Sagi Grimberg wrote:
> We don't have any other information today, but sector is not the only
> information that is requires a descriptor format, so maybe it will be a
> bit awkward to condition the descriptor format on the sector info?

The only reason why you'd want to support descriptor type sense data is
because you need to add a second descriptor.  If we have another case
that needs descriptor sense data it'll also need to add that additional
descriptor.  So we'll need a conditional for it in the sense data
generation anyway.
