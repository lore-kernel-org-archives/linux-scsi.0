From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] fix for Incorrect number of segments after building	list problem
Date: Wed, 20 Oct 2004 19:47:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041020174752.GT10531@suse.de>
References: <1097790683.1717.47.camel@mulgrave> <20041020143940.GK10531@suse.de> <20041020150708.GN10531@suse.de> <1098287481.2008.6.camel@mulgrave> <20041020155825.GP10531@suse.de> <1098288465.2008.13.camel@mulgrave> <4176A448.5040508@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:55493 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S268861AbUJTRsg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 13:48:36 -0400
Content-Disposition: inline
In-Reply-To: <4176A448.5040508@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, 'Dave Olien' <dmo@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Oct 20 2004, Jeff Garzik wrote:
> James Bottomley wrote:
> >slight problem is testing.  Only SATA and IDE have this short descriptor
> >problem, so I've nothing really to test the actual fix with.
> 
> 
> Clearly we need to remedy this :)

By improving James' imagination? :)

-- 
Jens Axboe

