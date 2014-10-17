From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Off-by-one LUN validation in scsi_scan_host_selected()?
Date: Fri, 17 Oct 2014 06:23:44 -0700
Message-ID: <20141017132344.GI16538@infradead.org>
References: <20141007220858.f256d6a7c54f6dc1a71ffab4@clara.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41231 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbaJQNXp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Oct 2014 09:23:45 -0400
Content-Disposition: inline
In-Reply-To: <20141007220858.f256d6a7c54f6dc1a71ffab4@clara.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Knibbs <markk@clara.co.uk>
Cc: linux-scsi@vger.kernel.org

On Tue, Oct 07, 2014 at 10:08:58PM +0100, Mark Knibbs wrote:
> Shouldn't the LUN check in scsi_scan_host_selected() be
> (lun >= shost->max_lun)?

Seems so.  Can you send a patch for it?

