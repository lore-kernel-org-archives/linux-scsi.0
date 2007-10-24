From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: stex driver panic in kernel 2.6.23
Date: Wed, 24 Oct 2007 15:29:36 -0400
Message-ID: <1193254176.3441.9.camel@localhost.localdomain>
References: <NONAMEWzsLqIfQdmEB40000023f@nonamew.ptu.promise.com>
	 <20071024121714.149b10c7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:43706 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754543AbXJXT3u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Oct 2007 15:29:50 -0400
In-Reply-To: <20071024121714.149b10c7.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ed Lin <ed.lin@promise.com>, "jens.axboe" <jens.axboe@oracle.com>, jeff <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2007-10-24 at 12:17 -0700, Andrew Morton wrote:
> On Wed, 24 Oct 2007 11:59:30 -0700 "Ed Lin" <ed.lin@promise.com> wrote:
> 
> > The shared tag issue was not fixed yet. Kernel panic
> > happened while running I/O test in kernel 2.6.23
> > (information attached). After applying the patch I posted
> > (or the version James modified), panic disappeared.
> > Switch back to standard kernel, panic again.
> 
> Did either of those patches get merged in 2.6.24-rc1?

No ... Jens did one instead (commit
f3da54ba140c6427fa4a32913e1bf406f41b5dda), which now looks like it might
not have fixed the issue.

James


