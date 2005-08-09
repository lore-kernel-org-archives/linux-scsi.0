From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Adaptec i2o controller
Date: Tue, 09 Aug 2005 11:11:26 -0500
Message-ID: <1123603886.5170.22.camel@mulgrave>
References: <42F8D2FD.6070107@possibilityforge.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:11656 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964853AbVHIQME (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 12:12:04 -0400
In-Reply-To: <42F8D2FD.6070107@possibilityforge.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jon Scottorn <jscottorn@possibilityforge.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-08-09 at 09:59 -0600, Jon Scottorn wrote:
>   I have been running a 2.6.8 kernel with the adaptec i2o scsi
> controller and I went to upgrade to the 2.6.12.4 kernel and when I
> reboot into that kernel I get a kernel panic. I am wondering either what
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


