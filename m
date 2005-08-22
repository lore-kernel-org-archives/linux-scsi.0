From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] correct attribute_container list usage
Date: Mon, 22 Aug 2005 16:59:16 -0500
Message-ID: <1124747956.5211.38.camel@mulgrave>
References: <1124723180.5211.25.camel@mulgrave>
	 <20050822214617.GA26441@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:42932 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750994AbVHVV7p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 17:59:45 -0400
In-Reply-To: <20050822214617.GA26441@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-08-22 at 14:46 -0700, Patrick Mansfield wrote:
> Did you test with CONFIG_DEBUG_SLAB enabled?

Yes, but only on an ia64.

> I have a workaround for problems with device_for_each_child() not being
> "safe", I'm trying to verify it right now, but the underlying problem is
> in klist_next(), I don't have a general solution for it (it looks hard to
> fix).

Could you elaborate ... the principle (hold refs to the node until
you've extracted the next pointer) looks sound to me, even in the face
of deletion.

James


