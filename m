From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] [Update] suspending I/Os to a device
Date: 03 Sep 2004 19:23:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094253813.1712.21.camel@mulgrave>
References: <0B1E13B586976742A7599D71A6AC733C02D93E@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:51604 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269973AbUICXXf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2004 19:23:35 -0400
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02D93E@xbl3.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@infradead.org, Mike Anderson <andmike@us.ibm.com>

On Fri, 2004-09-03 at 16:31, James.Smart@Emulex.Com wrote:
> Here's the patch updated based on Christoph's comments.

I'd still like to see the timer itself housed inside the transport
class.  Although, it needs to hang off something attached to the
sdev_target.  Let me see if I can cook up something that would do this.

James


