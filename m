From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 8/8] scsi tgt: IBM eServer i/pSeries virtual SCSI
 target driver
Date: Fri, 01 Dec 2006 02:06:24 +0900
Message-ID: <20061201020624Q.fujita.tomonori@lab.ntt.co.jp>
References: <20061116192426Y.fujita.tomonori@lab.ntt.co.jp>
	<20061128233117S.fujita.tomonori@lab.ntt.co.jp>
	<456EFAFB.4050206@us.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:145 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1030736AbWK3RGY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Nov 2006 12:06:24 -0500
In-Reply-To: <456EFAFB.4050206@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: santil@us.ibm.com, James.Bottomley@SteelEye.com
Cc: fujita.tomonori@lab.ntt.co.jp, boutcher@cs.umn.edu, linux-scsi@vger.kernel.org

From: Santiago Leon <santil@us.ibm.com>
Subject: Re: [PATCH 8/8] scsi tgt: IBM eServer i/pSeries virtual SCSI target driver
Date: Thu, 30 Nov 2006 09:38:35 -0600

> FUJITA Tomonori wrote:
> > Hi ibmvscsi team,
> > 
> > Can I get your ACK on this patch to get it merged into the scsi-misc?
> 
> No problem, Ive been playing with it for a while now.

Great!


> Just one tiny thing, Dave Boutcher has changed jobs within IBM, so
> please put me in the MODULE_AUTHOR() call.

Sure.

James, would you like me to submit an updated version of the patch?


> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH 8/8] scsi tgt: IBM eServer i/pSeries virtual SCSI target driver
> > Date: Thu, 16 Nov 2006 19:24:26 +0900
> > 
> >> This is IBM Virtual SCSI target driver for tgt. The driver is based on
> >> the original ibmvscsis driver:
> >>
> >> http://lkml.org/lkml/2005/10/17/99
> >>
> >>
> >> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> >> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> >> Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
> 
> Signed-off-by: Santiago Leon <santil@us.ibm.com>
> 
> -- 
> Santiago A. Leon
> Power Linux Development
> IBM Linux Technology Center
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
