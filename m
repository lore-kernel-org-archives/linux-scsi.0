From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Thu, 11 Aug 2005 09:51:14 -0500
Message-ID: <1123771874.5062.13.camel@mulgrave>
References: <OFDD993463.B29B392A-ONC125705A.004F39C4-C125705A.004FE950@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:6306 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751067AbVHKOvR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 10:51:17 -0400
In-Reply-To: <OFDD993463.B29B392A-ONC125705A.004F39C4-C125705A.004FE950@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harald Seipp <SEIPP@de.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-08-11 at 16:32 +0200, Harald Seipp wrote:
> Ok - but shouldn't the behavior that devices that have mounted partitions
> can be removed be considered as a bug?

Not really.  We remove as much as we can and leave it up to the hotplug
scripts to detach the mount point (any further I/O's will error).

If there's a reattachment udev should identify the device (even if it's
on a different node) and do the right thing.

Essentially in 2.6 resolution of this problem is pushed up to the user
as a policy decision.

James


