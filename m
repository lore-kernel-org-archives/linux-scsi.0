From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Patch] Fix Suspend I/O block/unblock patch
Date: 16 Oct 2004 11:39:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097944773.2283.123.camel@mulgrave>
References: <0B1E13B586976742A7599D71A6AC733C02F20B@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:52940 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268779AbUJPQjh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Oct 2004 12:39:37 -0400
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F20B@xbl3.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-10-14 at 09:31, James.Smart@Emulex.Com wrote:
> In further testing of the fc block/unblock patch, the recommendation to use device_for_each_child() instead of shost_for_each_device() in the target functions was not a good one. The calling sequences on the unblock path, which may eventually block, are not good for device_for_each_child(), which takes and holds a semaphore.

Could you give an example of this problem?  If there's a demonstrable
issue with device_for_each_child(), we can probably persuade Greg to
alter it.

James


