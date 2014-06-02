From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] mpt3sas: fix possible memory leak in
 mpt3sas_send_trigger_data_event
Date: Mon, 2 Jun 2014 09:31:50 -0700
Message-ID: <20140602163150.GB26828@infradead.org>
References: <1401719672-18352-1-git-send-email-joe.lawrence@stratus.com>
 <1401719846-18446-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51069 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaFBQbv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 12:31:51 -0400
Content-Disposition: inline
In-Reply-To: <1401719846-18446-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

On Mon, Jun 02, 2014 at 10:37:26AM -0400, Joe Lawrence wrote:
> If mpt3sas_send_trigger_data_event exits early without inserting a
> fw_event, be sure to undo any prior allocations.

Looks good, but why don't we just allocate the two in a single
allocation?

Reviewed-by: Christoph Hellwig <hch@lst.de>
