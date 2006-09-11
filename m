From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: lp8000 and 2.6.18-rc6
Date: Mon, 11 Sep 2006 12:00:26 -0500
Message-ID: <1157994026.3470.3.camel@mulgrave.il.steeleye.com>
References: <20060909210856.GC21263@stat.unipd.it>
	 <20060910135631.GD29775@parisc-linux.org>
	 <20060910210444.GC22873@stat.unipd.it> <4504B6AF.3080909@torque.net>
	 <20060911064008.GA26293@stat.unipd.it>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:21191 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751127AbWIKRAc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Sep 2006 13:00:32 -0400
In-Reply-To: <20060911064008.GA26293@stat.unipd.it>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alberto Cammozzo <mmzz@stat.unipd.it>
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-09-11 at 08:40 +0200, Alberto Cammozzo wrote:
> standard INQUIRY:
>   PQual=1  Device_type=0  RMB=0  [ANSI_version=4]  version=0x04

That's the reason:  Peripheral Qualifier Not Connected.  sd won't bind
to this device.

So, the next thing that would be tried is a report lun scan which seems
to have failed for some reason.

What does

sg_luns -v /dev/sg6

give?

Thanks,

James


