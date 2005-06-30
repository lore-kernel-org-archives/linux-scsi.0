From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 2/2] - mptfusion - FC Transport Support
Date: Thu, 30 Jun 2005 09:27:41 -0400
Message-ID: <1120138061.5125.3.camel@mulgrave>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F4140@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:37774 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262968AbVF3N1z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jun 2005 09:27:55 -0400
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F4140@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Eric.Moore@lsil.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-06-24 at 14:34 -0400, James.Smart@Emulex.Com wrote:
> To be honest, if I could have killed it (target-based object
> in sysfs), I would have as part of the FC transport rework. There was
> unfortunately too many app side things (udev, etc) that refer to it.
> This object is really a lame-duck.

Surely udev is about the only problem ... and we should be able to
persuade Greg to change easily enough.  It does seem that all of the
port information belongs in the rport, and so the attributes should be
deprecated and eventually eliminated.  Are you planning to do this?

James


