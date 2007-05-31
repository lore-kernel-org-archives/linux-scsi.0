From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] fix for BZ 8426 - massive slowdown on SCSI
	CD/DVDdriveconnected to mptspi driver
Date: Thu, 31 May 2007 11:14:11 -0500
Message-ID: <1180628051.3743.34.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D707881DB@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:33565 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752826AbXEaQON (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 May 2007 12:14:13 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D707881DB@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi@vger.kernel.org, Doug Chapman <doug.chapman@hp.com>

On Thu, 2007-05-31 at 09:40 -0600, Moore, Eric wrote:
> James -   I obtained a log from Doug (attached), and the firmware is
> returning BUSY, so your correct.  That will end up as a ADD_TO_MLQUEUE
> disposition.   Does the mid-layer throttle back the queue when a device
> returns busy, I don't know?    I still believe that the lld shouldn't
> report that a device supports tagged when it really doesn't.    I hope
> you will consider this patch, if not, let me know how to proceed.

Sorry, yes ... I should have said that the patch is correct and I'll put
it in 2.6.22

However, since we have such a wonderful example of the failing case, I'd
like to try to correct the root cause, if I may.  Doug, would you be
amenable to testing out a few patches for me?

James


