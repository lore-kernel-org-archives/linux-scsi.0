From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Thu, 17 Jul 2003 10:59:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030717085952.GX833@suse.de>
References: <1058310172.981.7.camel@markh1.pdx.osdl.net> <1058359278.1856.8.camel@mulgrave> <20030716124549.GX833@suse.de> <1058360162.1850.15.camel@mulgrave> <20030716132036.GB833@suse.de> <1058364455.1856.28.camel@mulgrave> <20030716170456.GK833@suse.de> <20030717015756.135a3f5a.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:47492 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S271388AbTGQIpM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 04:45:12 -0400
Content-Disposition: inline
In-Reply-To: <20030717015756.135a3f5a.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James.Bottomley@steeleye.com, markh@osdl.org, piggin@cyberone.com.au, cliffw@osdl.org, linux-scsi@vger.kernel.org

On Thu, Jul 17 2003, Andrew Morton wrote:
> 
> So this is what I ended up with.  Could we please have confirmation that it
> fixes the aacraid hang?

It doesn't, it's just a pre-requisite to fixing the bug :-)

Nick should chime in with how we wants it to be handled from
blk_requeue_request(), he needs to decrease dispatched from there. We
could always add some hook for it of course, but...

-- 
Jens Axboe

