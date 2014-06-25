From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RESEND] [SCSI] aic94xx: Remove broken fallback for
 missing 'Ctrl-A' user settings
Date: Wed, 25 Jun 2014 13:12:44 +0200
Message-ID: <20140625111244.GB19415@infradead.org>
References: <1402267064.23860.42.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57901 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbaFYLK1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 07:10:27 -0400
Content-Disposition: inline
In-Reply-To: <1402267064.23860.42.camel@deadeye.wl.decadent.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Jun 08, 2014 at 11:37:44PM +0100, Ben Hutchings wrote:
> asd_process_ctrl_a_user() attempts to find user settings in flash, and
> if they are missing it prepares a substitute structure containing
> default values for PHY settings.  But having done so, it will still
> try to read user settings - from some random address in flash, as the
> local variable 'offs' has not been initialised.
> 
> Since asd_common_setup() already sets default PHY settings, there
> seems to be no need to repeat them here, and we can just return 0.
> 
> Compile-tested only.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Can I get another review, too please?
