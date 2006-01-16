From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] Update aic79xx to 2.0.15
Date: Mon, 16 Jan 2006 11:43:02 +0000
Message-ID: <20060116114302.GA12069@infradead.org>
References: <43CB6EE9.3070400@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:17852 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750996AbWAPLnF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2006 06:43:05 -0500
Content-Disposition: inline
In-Reply-To: <43CB6EE9.3070400@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jan 16, 2006 at 11:01:13AM +0100, Hannes Reinecke wrote:
> Hi James,
> 
> this is the last aic79xx update; it updates the aic79xx driver to the
> latest adaptec version 2.0.15. This patchset also adds two README files
> for aic7xx and aic79xx to drivers/scsi/aic7xxx. Please let me know if
> that's not the correct place (eg. if they should better be moved to
> Documentation).

Yeah, documentation should go to Documentation/.  For scsi drivers that'd
be Documentation/scsi/<driver>.txt, which already contains older versions
of the files you're adding.  The new ones have rather odd copyright
statements and a rather strange (altough probably GPL-compatible) license.
So instead update the existing files and remove the rather outdated and
misleading changelog in there completely.

