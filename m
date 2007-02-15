From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: sg version 4 tools
Date: Thu, 15 Feb 2007 23:47:02 +0100
Message-ID: <20070215224701.GA21772@kernel.dk>
References: <20070214153508Z.fujita.tomonori@lab.ntt.co.jp> <45D48990.70607@torque.net> <20070215085845L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:21475 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161613AbXBOWrJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Feb 2007 17:47:09 -0500
Content-Disposition: inline
In-Reply-To: <20070215085845L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

On Fri, Feb 16 2007, FUJITA Tomonori wrote:
> If you add sgv4 support to sg3_utils now, I'm happy to remove the git
> tree. :)

I think keeping a private testing tools git repo for sg v4 makes a lot
of sense. Some/most of these tools are just for playing around and
making sure that things still work, it's not mean to be packaged for
distros or anything like that.

sg v4 is still in early development, and things change. Integrating
anything with the sg3 tools package at this point would be a big
mistake.

-- 
Jens Axboe

