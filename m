From: Jens Axboe <axboe@suse.de>
Subject: Re: PATCH [5/15] qla2xxx:  SG tablesize update
Date: Sun, 14 Mar 2004 15:51:42 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314145142.GL6955@suse.de>
References: <20040314082444.GA3416@linux.local.home> <1079275768.2022.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:34270 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263372AbUCNOw2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 09:52:28 -0500
Content-Disposition: inline
In-Reply-To: <1079275768.2022.1.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, Mar 14 2004, James Bottomley wrote:
> On Sun, 2004-03-14 at 03:24, Andrew Vasquez wrote:
> > -	.sg_tablesize		= SG_ALL,
> > +	.sg_tablesize		= 32,
> 
> Are you sure you want to do this?  It limits the maximum transfer size
> per command to 128k (on x86) which is a bit small for FC.

The explanation of why this was done (request queue limitations, huh?)
sounded pretty bogus as well.

-- 
Jens Axboe

