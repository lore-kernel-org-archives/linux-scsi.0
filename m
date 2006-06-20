From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] scsi_transport_sas: introduce a sas_port entity
Date: Tue, 20 Jun 2006 12:45:00 -0500
Message-ID: <1150825500.10891.45.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D7019A013@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:50386 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750724AbWFTRpF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jun 2006 13:45:05 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7019A013@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2006-06-20 at 11:37 -0600, Moore, Eric wrote:
> The scsi-misc-2.6 patch with todays date in your kernel.org
> home folder has all the wide port API changes backed out?  
> Is that on purpose, and what is your plans for your 2.6.18
> push to Linus having this?

I plan to push the current SCSI misc and hopefully follow on with the
wide port API before the 2.6.18 merge window closes.  I suspect the next
round of kernel releases will be Andrew's requested stability ones, so
if we don't get something in before 1 July, it will likely be 2.6.20 (or
four to six months) before we can get this API in.

James


