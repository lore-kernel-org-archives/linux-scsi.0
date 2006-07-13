From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 1/10] mptfusion : Transport Layer Retry support
Date: Thu, 13 Jul 2006 16:52:05 -0400
Message-ID: <1152823926.3601.24.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D701F693B@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:60800 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030383AbWGMUwR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jul 2006 16:52:17 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D701F693B@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

On Thu, 2006-07-13 at 14:45 -0600, Moore, Eric wrote:
> SPC-3 Section 8, of spc3r23.pdf, says W-LUN only covers
> inquiry, report luns, request sense, and test unit ready.
> 
> I couldn't find where it says it worked for mode page 18h,
> protocol-specfic lu page.

Yes, sorry, forget that ... I was just looking for an easy way around
this without altering the standards ... although it looks like HP is
beginning that route.  In my haste I misread REQUEST SENSE for MODE
SENSE.

James


