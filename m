From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: lp8000 and 2.6.18-rc6
Date: Wed, 13 Sep 2006 10:20:41 -0500
Message-ID: <1158160841.3462.10.camel@mulgrave.il.steeleye.com>
References: <20060909210856.GC21263@stat.unipd.it>
	 <20060910135631.GD29775@parisc-linux.org>
	 <20060910210444.GC22873@stat.unipd.it> <4504B6AF.3080909@torque.net>
	 <20060911064008.GA26293@stat.unipd.it>
	 <1157994026.3470.3.camel@mulgrave.il.steeleye.com>
	 <20060912064514.GA28121@stat.unipd.it>
	 <1158156671.3462.7.camel@mulgrave.il.steeleye.com>
	 <45081936.4040209@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:165 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750923AbWIMPUr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Sep 2006 11:20:47 -0400
In-Reply-To: <45081936.4040209@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Alberto Cammozzo <mmzz@stat.unipd.it>, linux-scsi@vger.kernel.org

On Wed, 2006-09-13 at 10:44 -0400, Douglas Gilbert wrote:
> No lun 0 either hence the PQual=1 for the inquiry
> response for /dev/sg6 ('sg_inq /dev/sg6'). I suspect
> 'sg_inq /dev/sg7', sg8 and sg9 also have PQual=1.
> There may be a similar pattern to 'sg_luns /dev/sg7',
> sg8 and sg9 as was reported for 'sg_luns /dev/sg6'.

Actually, I don't think so.  The requirement for report luns is that PQ
0 must be included, PQ 1 may be included and PQ 3 must not be included.
However, since LUN 0 doesn't show and it's PQ 1 the array must have
chosen not to include PQ 1; therefore the shown LUNS at 1 3 4 should be
PQ 0.  (although I suppose the discrepancy at LUN 2 could be because
that one is PQ 1).

James


