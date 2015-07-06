From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/3] target: Inline transport_get_sense_codes()
Date: Mon, 6 Jul 2015 01:59:58 -0700
Message-ID: <20150706085958.GA15996@infradead.org>
References: <1436169747-28834-1-git-send-email-sagig@mellanox.com>
 <1436169747-28834-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51071 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbbGFI77 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2015 04:59:59 -0400
Content-Disposition: inline
In-Reply-To: <1436169747-28834-2-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

On Mon, Jul 06, 2015 at 11:02:25AM +0300, Sagi Grimberg wrote:
> From: Bart Van Assche <bart.vanassche@sandisk.com>
> 
> Inline this function in its call site since it performs a trivial
> task and since it is only called once.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Sagi: if you send on Barts patches you probably should add your signoff
as well.
