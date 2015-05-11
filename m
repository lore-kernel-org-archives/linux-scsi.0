From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/17] scsi_dh: return individual errors in
	scsi_dh_activate()
Date: Mon, 11 May 2015 08:34:32 +0200
Message-ID: <20150511063432.GA30516@lst.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38898 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbbEKGed (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 02:34:33 -0400
Content-Disposition: inline
In-Reply-To: <1430743343-47174-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Mon, May 04, 2015 at 02:42:07PM +0200, Hannes Reinecke wrote:
> When calling scsi_dh_activate() we should be returning
> individual errors and not lumping all into one.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

(although you might need a rebase, my v2 post has some white space changes
that git-am complained about, sorry)
