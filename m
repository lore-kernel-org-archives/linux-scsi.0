From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6 08/08] scsi: fix hot unplug sequence
Date: Wed, 23 Mar 2005 09:20:12 -0600
Message-ID: <1111591213.5441.19.camel@mulgrave>
References: <20050323021335.960F95F8@htj.dyndns.org>
	 <20050323021335.4682C732@htj.dyndns.org>
	 <1111550882.5520.93.camel@mulgrave> <4240F5A9.80205@gmail.com>
	 <20050323071920.GJ24105@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:54656 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261648AbVCWPU2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2005 10:20:28 -0500
In-Reply-To: <20050323071920.GJ24105@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Tejun Heo <htejun@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Wed, 2005-03-23 at 08:19 +0100, Jens Axboe wrote:
> It is not the oops I am getting. When I get a few minutes today, I'll
> reproduce with vanilla and post it here.

Well, I have news too.  Unfortunately, the python script I posted is
hanging in D wait.  When I tested all of this out (with a similar
script) in the 2.6.10 timeframe, it wasn't doing this, so we have some
other problem introduced into the stack since then, sigh.

Also it means my test isn't effective, so I need to track down the
open/close hang before I can make progress.

James


