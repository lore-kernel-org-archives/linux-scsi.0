From: Kyle McMartin <kyle@infradead.org>
Subject: Re: [PATCH trivial] mvsas: fix build warning about enum comparisons
Date: Wed, 8 May 2013 09:49:52 -0400
Message-ID: <20130508134952.GD20643@bombadil.infradead.org>
References: <20130507165704.GB20643@bombadil.infradead.org>
 <1367961637.4108.15.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47500
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755406Ab3EHNtx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 May 2013 09:49:53 -0400
Content-Disposition: inline
In-Reply-To: <1367961637.4108.15.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, yuxiangl@marvell.com

On Tue, May 07, 2013 at 02:20:37PM -0700, James Bottomley wrote:
> On Tue, 2013-05-07 at 12:57 -0400, Kyle McMartin wrote:
> > device_type is a sas_device_type, not a sas_dev_type.
> 
> Heh, months ago, someone who submitted the same trivial but insufficient
> fix was asked to go and see if they could unify sas_device_type and
> sas_dev_type, which is the correct fix.  They were never heard from
> again.  I suppose that shows that if you want something doing properly,
> you should do it yourself.
> 

Woops, sorry James, I only looked at the last two months of archives for
mvsas patches.

Thanks for fixing this.

regards, Kyle
