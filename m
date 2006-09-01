From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] block: add support for shared tag maps
Date: Fri, 01 Sep 2006 16:52:34 -0400
Message-ID: <1157143954.3675.21.camel@mulgrave.il.steeleye.com>
References: <NONAMEBh8GyUbvH4KQ700000f3d@nonameb.ptu.promise.com>
	 <1157117328.3675.6.camel@mulgrave.il.steeleye.com>
	 <20060901190423.806416@bebe.enoyolf.org>
	 <20060901202109.GD7941@ranandlinuxbox.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:15246 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750799AbWIAUxb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Sep 2006 16:53:31 -0400
In-Reply-To: <20060901202109.GD7941@ranandlinuxbox.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Doug Maxey <dwm@enoyolf.org>, mikec linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

On Fri, 2006-09-01 at 13:21 -0700, Ravi Anand wrote:
> Dont know much about stex driver. So cant comment on it. 
> James any thought ? 

The stex driver has a shared tag map (which is tiny:32) so it just sets
the can_queue and the tag depth to the same value.

James



-- 
VGER BF report: H 1.02918e-13
