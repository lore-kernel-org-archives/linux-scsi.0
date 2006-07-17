From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 1/10] mptfusion : Transport Layer Retry support
Date: Mon, 17 Jul 2006 15:22:06 -0400
Message-ID: <1153164126.3704.2.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D7022583D@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:58306 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750808AbWGQTWZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Jul 2006 15:22:25 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7022583D@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: Andrew Patterson <andrew.patterson@hp.com>, dougg@torque.net, linux-scsi@vger.kernel.org, elliott@hp.com, "Johnson, Steve" <Steve.Johnson@lsil.com>, "Rivera, Peter" <Peter.Rivera@lsil.com>, "Besmer, Brad" <Brad.Besmer@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>

On Mon, 2006-07-17 at 12:38 -0600, Moore, Eric wrote:
> Which bit is in consideration for being set? In the ssp frame header
> or
> IU?

Well, the way I read it, the IU isn't part of the frame header, so I was
assuming it would be using one of the five reserved bits of byte 10 of
the SSP header.

I assume you're asking because the fusion doesn't need a firmware change
to place this in the IU?

James


