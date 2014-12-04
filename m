From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] scsi: remove ->change_queue_type method
Date: Thu, 4 Dec 2014 10:10:44 +0100
Message-ID: <20141204091044.GA23870@lst.de>
References: <1416839781-26988-1-git-send-email-hch@lst.de> <1416839781-26988-2-git-send-email-hch@lst.de> <547F10D4.60605@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57337 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbaLDJKs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 04:10:48 -0500
Content-Disposition: inline
In-Reply-To: <547F10D4.60605@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Doug Ledford <dledford@redhat.com>

On Wed, Dec 03, 2014 at 02:32:04PM +0100, Hannes Reinecke wrote:
> Why not setting the attribute to S_IRUGO always and drop the 'store'
> method altogether?

For now I'm printing a warning if someone writes to it.  I the long
run we can simply mark it r/o.

