From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 2.6.9-rc1] add blacklist attribute indicating no ULD attach
Date: Thu, 16 Sep 2004 07:42:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040916054247.GA2300@suse.de>
References: <20040914063237.GA97486@sgi.com> <20040914144023.GA9524@beaverton.ibm.com> <20040914182203.GA100433@sgi.com> <20040915031834.GA102988@sgi.com> <20040915074744.A17264@infradead.org> <1095254765.1717.0.camel@mulgrave> <20040916004125.GA108136@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:19636 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261234AbUIPFok (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2004 01:44:40 -0400
Content-Disposition: inline
In-Reply-To: <20040916004125.GA108136@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>

On Wed, Sep 15 2004, Jeremy Higdon wrote:
> Add blacklist attribute to disable ULD attachment to a lun, and use
> that attribute for SGI-branded Engenio UTM luns.
> 
> This incorporates input on braces :-)

Your style is now exemplary, the patch should be hung on the refigerator
as a good example for the entire family :-)

I think the patch should be included.

-- 
Jens Axboe

