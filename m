From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Adaptec i2o controller
Date: Tue, 9 Aug 2005 12:16:44 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F016845E2@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:39556 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S964862AbVHIQSy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 12:18:54 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jon Scottorn <jscottorn@possibilityforge.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This dpt_i2o patch *plus* the patch Markus submitted yesterday for the
i2o driver to the kernel list need to be performed to create the mutual
exclusion between the two drivers.

Jon, just select one (CONFIG_SCSI_DPT_I2O) or the other (CONFIG_I2O) in
your .config

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of James Bottomley
Sent: Tuesday, August 09, 2005 12:11 PM
To: Jon Scottorn
Cc: SCSI Mailing List
Subject: Re: Adaptec i2o controller

On Tue, 2005-08-09 at 09:59 -0600, Jon Scottorn wrote:
>   I have been running a 2.6.8 kernel with the adaptec i2o scsi
> controller and I went to upgrade to the 2.6.12.4 kernel and when I
> reboot into that kernel I get a kernel panic. I am wondering either
what
> I have done wrong or what has changed with the i2o driver between the
> two kernels. 
> Here is the error I get, I am summarizing because I have to type the
> error in.
> 
> EIP is at adpt_isr+0x175/0x1f2
> then has a stack and call trace:
> (#0001,*0):c01035b2 oops
> kernel panic - not syncing: Fatal exception in interrupt

Could you try out the patch in this email:

http://marc.theaimsgroup.com/?l=linux-scsi&m=112351014310129

Thanks,

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
