From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [patch 4/7] scsi/qla_os: replace schedule_timeout() with
	ssleep()
Date: Fri, 14 Jan 2005 08:50:34 -0800
Message-ID: <1105721434.12434.9.camel@plap.san.rr.com>
References: <20050111232257.909231F226@trashy.coderock.org>
	 <1105547532.5577.18.camel@mulgrave>  <20050112234314.GB2688@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:55970 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261756AbVANQuZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2005 11:50:25 -0500
In-Reply-To: <20050112234314.GB2688@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, domen@coderock.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-01-12 at 15:43 -0800, Nishanth Aravamudan wrote:
> On Wed, Jan 12, 2005 at 10:32:11AM -0600, James Bottomley wrote:
> > On Wed, 2005-01-12 at 00:22 +0100, domen@coderock.org wrote:
> > > Description: Use ssleep() instead of schedule_timeout() to guarantee the
> > [...]
> > > -		set_current_state(TASK_UNINTERRUPTIBLE);
> > > -		schedule_timeout(ABORT_POLLING_PERIOD);
> > > +		msleep(ABORT_POLLING_PERIOD);
> > 
> > The description doesn't match the code.
> > 
> > Also, the qla driver is maintained.  You should cc
> > andrew.vasquez@qlogic.com (I know they don't make it easy, like having
> > an entry in the MAINTAINERS file or even an email address in the code).
> 
> Please find the corrected Description with this patch (and the appropriate CC).
> Thanks!
> 
> -Nish
> 
> Description: Use msleep() instead of schedule_timeout() to guarantee the
> task delays as expected. Change the values of the constants being used
> appropriately. I left the arithmetic there as it was before, even though
> it could be easily simplified away.
> 
> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> Signed-off-by: Domen Puncer <domen@coderock.org>

ACK.

James, please add to your tree.

I'll forward over a diff to add an entry to the MAINTAINERS file in
another email.

Thanks,
Andrew Vasquez
