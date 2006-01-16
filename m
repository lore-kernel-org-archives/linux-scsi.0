From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] aic79xx: update aicasm
Date: Mon, 16 Jan 2006 12:01:28 +0000
Message-ID: <20060116120128.GA12554@infradead.org>
References: <43CB6F47.10108@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:8909 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750720AbWAPMBa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2006 07:01:30 -0500
Content-Disposition: inline
In-Reply-To: <43CB6F47.10108@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jan 16, 2006 at 11:02:47AM +0100, Hannes Reinecke wrote:
> Update aicasm with fixes from adaptec.
> 
> 

> [PATCH 1/3] aic79xx: update aicasm
> 
> Update aicasm with fixes from adaptec.

this introduced changes that patch 2 backs out again and patch 3 reintroduces
again.  Can you please try to resplit the whole patchkit, aka apply everything
to a tree and split it into a few patches doing one logical thing at a time,
e.g.:

 - update aicasm
 - update sequencer code
 - add slowcrc workaround

