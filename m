From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] - Fusion-MPT much faster as module
Date: Tue, 22 Mar 2005 13:05:23 -0600
Message-ID: <1111518323.5520.60.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C01AEB0A8@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:56543 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261659AbVCVTFc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2005 14:05:32 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C01AEB0A8@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, kenneth.w.chen@intel.com

On Tue, 2005-03-22 at 11:40 -0700, Moore, Eric Dean wrote:
> History on this:
> Between the 3.01.16 and 3.01.18, we introduced new method
> to passing command line options to the driver.  Some of the
> command line options are used for fine tuning dv(domain
> validation) in the driver.  By accident, these command line options were
> wrapped around #ifdef MODULE in the 3.01.18 version of the driver.
> What this meant is when the driver is compiled built-in the kernel,
> the optimal settings for dv were ignored, thus poor performance.  

OK, I'll add this to the queue.

Could I just point out that if your driver actually printed the results
of negotiation, this would have been an awful lot easier to debug.

Additionally, if you used the SPI transport class domain validation, the
issue wouldn't have arisen in the first place.

James


