From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: restart list search after unlock in
 scsi_remove_target
Date: Fri, 30 Oct 2015 09:26:35 +0100
Message-ID: <1446193595.16404.51.camel@suse.de>
References: <20151019143546.GA7486@lst.de>
	 <1445848537.16404.26.camel@suse.de> <562FDB30.1060304@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43229 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759191AbbJ3I0g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 04:26:36 -0400
In-Reply-To: <562FDB30.1060304@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

Hi Bart,
On Tue, 2015-10-27 at 13:14 -0700, Bart Van Assche wrote:
> On 10/26/2015 01:35 AM, Johannes Thumshirn wrote:
> > I haven't heard anything from the original reporter of the lockup
> > but
> > my test's went all O.K., so
> > 
> > Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
> > Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> 
> Hello Christoph and Johannes,
> 
> How about the patch below, which is a variant of Christoph's patch ?
> 
> Thanks,
> 
> Bart.


I'm OK with it and I ran tests with it over night, no lockups happened.
I feel a bit reluctant of giving the patch to mt downsream reporter as
it's not their business to validate patches for me.

So from my POV it's OK as well. So please feel free to add

Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

on the official submission.

Thanks,
	Johannes

