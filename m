From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 1/10] mptfusion : Transport Layer Retry support
Date: Wed, 12 Jul 2006 15:25:37 -0400
Message-ID: <1152732337.4086.19.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D701F667B@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:1193 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750837AbWGLTZl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jul 2006 15:25:41 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D701F667B@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

On Wed, 2006-07-12 at 13:18 -0600, Moore, Eric wrote:
> If the mode pages method worked properly, they wouldn't had to go this
> other route.  

Well .. yes ... however, it does look like they should be able to get at
this via the mode pages of the Report Luns W-LUN, which wouldn't suffer
either the reservations issue and should be immune from the busy
wait ...

> Ok, since this patch was the head of the queue, will you need
> a respin of all the other patchs I posted yesterday?

As long as they all apply without this one, I should be OK.

James


