From: maximilian attems <janitor@sternwelten.at>
Subject: Re: [patch 08/10]  scsi/dpt_i2o: replace 	schedule_timeout()withmsleep_interruptible()
Date: Sun, 24 Oct 2004 16:03:43 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041024140343.GA23059@stro.at>
References: <60807403EABEB443939A5A7AA8A7458B40B611@otce2k01.adaptec.com> <20041022232225.GA18906@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:30881 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S261497AbUJXODz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 10:03:55 -0400
Content-Disposition: inline
In-Reply-To: <20041022232225.GA18906@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 22 Oct 2004, Nishanth Aravamudan wrote:

> On Thu, Oct 21, 2004 at 10:11:31AM -0400, Salyzyn, Mark wrote:
> > I have to speak in absence of the original author, but I believe the
> > decision to conditionalize the unlock was because this routine is called
> > at init time and at run time.
> > 
> > I did not notice the `stutter' of the two schedule_timeout's. Eeeeek!!!
> > (My scientific replacement for bogus). Thanks for shaking the cobwebs.
> > 
> > The second schedule_timeout needs to be *removed*, it does not belong
> > there at all!
> 
> Please find below a patch which does exactly this.
> 
> Description: Removes a schedule_timeout() from adpt_i2o_post_wait() whch
> Mark Salyzyn requested be removed.
 
this patch seems already applied in 2.6.10-rc1.
please double check.

thanks maks

