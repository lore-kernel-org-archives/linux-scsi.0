From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] SCSI: early detection of medium not present, updated
Date: Sat, 01 Dec 2007 16:24:59 +0200
Message-ID: <1196519099.5977.3.camel@localhost.localdomain>
References: <20071129151842.44c05b18.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35874 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752197AbXLAOZF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Dec 2007 09:25:05 -0500
In-Reply-To: <20071129151842.44c05b18.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, Albert Lee <albertcc@tw.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <htejun@gmail.com>, Jens Axboe <jens.axboe@oracle.com>


On Thu, 2007-11-29 at 15:18 -0800, Andrew Morton wrote:
> Guys, I have this marked as needed-in-2.6.24?

Could you wait on this a bit ... since it's such an old bug.  The code
in question needs to be reworked (as the comment says).  I think the
best rework is to have the caller pass in an optional struct
scsi_sense_header into scsi_test_unit_ready() instead of the hacky
media_may_be_present, so the one place that needs this will be able to
interpret the sense codes correctly.

I can do this when I get back home ... unfortunately, I'm in Aswan toda=
y
at an Internet caf=C3=A9 ... I'll be back in Cairo tomorrow, but my US =
system
seems to have fallen off the internet, so I might not be able to test
any patches I come up with.  Worst case, I'll be back in Chicago on
Thursday.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
