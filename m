From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] improvement of fastfail operation
Date: 01 Apr 2004 10:06:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080832011.2117.8.camel@mulgrave>
References: <1080696593.2075.120.camel@mulgrave>
	<Pine.LNX.4.44.0403302108550.7851-200000@dyn319701.beaverton.ibm.com>
	<20040331220416.GQ24370@suse.de> <1080771068.2071.48.camel@mulgrave>
	<20040331221241.GR24370@suse.de> <406B512F.9090004@us.ibm.com>
	<406BC50E.6090100@us.ibm.com>  <406BCA7D.40208@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:8155 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262508AbUDAPHl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 10:07:41 -0500
In-Reply-To: <406BCA7D.40208@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>

On Thu, 2004-04-01 at 02:53, Mike Christie wrote:
> The attached patch fixes the leftover calculation for both
> blk pc and blk fs requests per Jens's comments. It was
> built against 2.6.5-rc3.

Actually, I already put an identical patch in the misc tree yesterday.

James


