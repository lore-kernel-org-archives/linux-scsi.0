From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: PATCH [5/15] qla2xxx:  SG tablesize update
Date: Mon, 15 Mar 2004 22:40:37 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040316064037.GA618317@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0598FC6@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:1274 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S261680AbUCPVJA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2004 16:09:00 -0500
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598FC6@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jgarzik@pobox.com>, Anton Blanchard <anton@samba.org>, Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Mar 15, 2004 at 03:43:18PM -0800, Andrew Vasquez wrote:
> 
> Since the driver specifies SG_ALL for the sg_tablesize, from testing
> (x86 and ppc64), we've seen at most 128 SG entries attached to a
> command request of 512K bytes (4K page size * 128).  

Andrew, with a slight mod to your driver, and using James's patch
to issue larger requests, I was able to issue 4MB requests to a
device (256 SG entries times 16KB page size) on our Itanium box.

Some H/W RAIDs have a strong preference for really large requests.

Your plan to switch to the midlayer throttling mechanism sounds good.

jeremy
