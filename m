From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 09:13:20 +0200
Message-ID: <20050524071320.GW9855@suse.de>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com> <20050524070714.GU9855@suse.de> <4292D37C.5020700@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:60341 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261385AbVEXHQh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 03:16:37 -0400
Content-Disposition: inline
In-Reply-To: <4292D37C.5020700@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

On Tue, May 24 2005, Jeff Garzik wrote:
> Jens Axboe wrote:
> >On Tue, May 24 2005, Jeff Garzik wrote:
> >>I can describe how this will look when libata is divorced from SCSI, if 
> >>you would like, too...
> >
> >I was beginning to dispair you had given up that plan...
> 
> hehe, nope.  I promised Linus, and I plan to keep my promise :)

You promised me, too :)

> I know how to do it.  Internally things have been kept as separate as 
> possible from the SCSI layer.

We should start a list of items that could potentially be moved to the
block layer that libata currently uses.
> 
> Bart even hinted at possibly using libata-without-SCSI for future 
> /dev/hdX support.  It's certainly doable.

>From my point of view, I think it would be a good way to kick off
/dev/disk device agnostic mappings.

-- 
Jens Axboe

