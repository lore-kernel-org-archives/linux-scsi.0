From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] iscsi_ibft: search for broadcom specific ibft sign
Date: Wed, 7 May 2014 15:21:58 -0400
Message-ID: <20140507192158.GA17806@phenom.dumpdata.com>
References: <1399453220-21663-1-git-send-email-vikas.chaudhary@qlogic.com>
 <20140507134757.GC12826@phenom.dumpdata.com>
 <1399489950.2227.63.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46166 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaEGTXr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2014 15:23:47 -0400
Content-Disposition: inline
In-Reply-To: <1399489950.2227.63.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@qlogic.com" <giridhar.malavali@qlogic.com>, "konrad@kernel.org" <konrad@kernel.org>, "vikas.chaudhary@qlogic.com" <vikas.chaudhary@qlogic.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "pjones@redhat.com" <pjones@redhat.com>, "iscsi-driver@qlogic.com" <iscsi-driver@qlogic.com>

On Wed, May 07, 2014 at 07:12:31PM +0000, James Bottomley wrote:
> On Wed, 2014-05-07 at 09:47 -0400, Konrad Rzeszutek Wilk wrote:
> > On Wed, May 07, 2014 at 05:00:20AM -0400, vikas.chaudhary@qlogic.com wrote:
> > > From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> > > 
> > > Broadcom iscsi offload firmware uses a non standard ibft sign of "BIFT".
> > 
> > Why? If it uses the standard iBFT format why does it use
> > a non-standard signature?
> 
> This is useful as an academic exercise (and perhaps even a reminder to
> broadcom not to do it again) but I don't think we can make it a show
> stopper.  The boards have shipped with the non-standard signature, so we
> have to work with them.

I agree as the train has left, but this got me thinking about these
questions that I hope Qlogic folks could answer:

 - Mention what else is different - perhaps there are other entries that
   are a bit different? Or maybe the are some non-standard ones added on?

 - How has this been tested? As in had all the fields been tested (so CHAP
   on/off, extra ports, etc).

 - Do future hardware of these cards use the standard one? If so what are they?
   "Anything produced in 2012 and later.." ?
 - Is the subset of hardware that use the non-standard small enough? Would it
   be good to mention it in the commit.

Thanks!
> 
> James
> 
