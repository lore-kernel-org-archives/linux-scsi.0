From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [patch] Have qla2xxx driver bind fcports.
Date: 19 Jan 2004 12:11:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074532278.1645.24.camel@mulgrave>
References: <B179AE41C1147041AA1121F44614F0B0598E40@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:30950 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265294AbUASRLc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 12:11:32 -0500
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598E40@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-01-19 at 12:03, Andrew Vasquez wrote:
> BTW: This fix is already in the resync_bk-v8.00.00b9 patch up on the
> SF.net site.

Thanks, sorry about that.

As far as the resync goes, I'd like to wait a while just to see if any
more bugs turn up in the ioctl/failover separation piece ... it will be
easier to debug if we have fewer changes, so how does early 2.6.2 sound
for this (depending, of course, on when that actually is)?

James


