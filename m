From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: lp8000 and 2.6.18-rc6
Date: Sun, 10 Sep 2006 21:17:30 -0500
Message-ID: <1157941050.3467.21.camel@mulgrave.il.steeleye.com>
References: <20060909210856.GC21263@stat.unipd.it>
	 <20060910135631.GD29775@parisc-linux.org>
	 <20060910210444.GC22873@stat.unipd.it>  <4504B6AF.3080909@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:15274 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750899AbWIKCRh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Sep 2006 22:17:37 -0400
In-Reply-To: <4504B6AF.3080909@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: mmzz@stat.unipd.it, linux-scsi@vger.kernel.org

On Sun, 2006-09-10 at 21:06 -0400, Douglas Gilbert wrote:
> Type 0 is for disks, strange that sd didn't pick up
> those devices on host 7. Could you fetch the sg3_utils
> package, build it and try 'sg_inq /dev/sg6'. The output
> may be interesting.

That would be characteristic of a zoned array returning PQ not connected
(or not present) as James Smart suggested ...

sg_inq would confirm this theory.

James


