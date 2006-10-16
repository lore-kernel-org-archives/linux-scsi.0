From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic94xx IO errors with "escb_tasklet_complete: phy0:
	REQ_TASK_ABORT"
Date: Mon, 16 Oct 2006 15:00:09 -0500
Message-ID: <1161028809.3433.26.camel@mulgrave.il.steeleye.com>
References: <20061004164438.GC5091@rhun.haifa.ibm.com>
	 <20061004132929.A29689@florence.linkmargin.com>
	 <20061004205621.GF5091@rhun.haifa.ibm.com>
	 <1159996277.3437.83.camel@mulgrave.il.steeleye.com>
	 <20061016195122.GC5385@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:54739 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750782AbWJPUAn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 16:00:43 -0400
In-Reply-To: <20061016195122.GC5385@rhun.haifa.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andy Warner <andyw@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Darrick J. Wong" <djwong@us.ibm.com>

On Mon, 2006-10-16 at 21:51 +0200, Muli Ben-Yehuda wrote:
> I finally got a chance to try aic94xx in 2.6.19-rc2-git with the
> Razor_10a1 firmware. Works splendidly. This is fine as a workaround,
> but I'd like to get it working with the latest firmware version as
> well.

The sequencer firmware is a binary blob ... only adaptec know what's
actually in it ...

James


