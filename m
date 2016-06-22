From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/5] scsi: make eh_eflags persistent
Date: Wed, 22 Jun 2016 15:33:10 +0200
Message-ID: <20160622133309.GF6118@lst.de>
References: <1466415340-104465-1-git-send-email-hare@suse.de> <1466415340-104465-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52044 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbcFVNdL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2016 09:33:11 -0400
Content-Disposition: inline
In-Reply-To: <1466415340-104465-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, Jun 20, 2016 at 11:35:38AM +0200, Hannes Reinecke wrote:
> To detect if a failed command has been retried we must not
> clear scmd->eh_eflags when EH finishes.
> The flag should be persistent throughout the lifetime
> of the command.

Please explain what issue this solves - the behavior has been there
for a while and even documented, so explaining how this was wrong
would be very useful.
