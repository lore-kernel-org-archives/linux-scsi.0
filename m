From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] switch scsi upper driver probing to the driver model
Date: 17 May 2003 11:19:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1053188393.1968.97.camel@mulgrave>
References: <20030516182039.A7369@lst.de>
	<20030516235718.GA3260@beaverton.ibm.com>
	<Pine.LNX.4.52.0305171248460.4436@kai.makisara.local>
	<20030517160801.A9431@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:39684 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261617AbTEQQHq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2003 12:07:46 -0400
In-Reply-To: <20030517160801.A9431@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, Mike Anderson <andmike@us.ibm.com>, Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2003-05-17 at 10:08, Christoph Hellwig wrote:
> That exactly what I said in my mail to Douglas before - now there always
> is one driver for each device.  If you have sg loaded but not st (yet)
> sg will claim your tapes, not st.

In principle, I'm not opposed to single attachment.  However, we need
the SG_IO demonstrably working for all devices (including tape) before
we try turning it off.

So, let's look at the SG_IO for cdev patch before considering this one.

James


