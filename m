From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: [Bugme-new] [Bug 7999] New: MegaRAID Legacy doesn't work
	with LSI MegaRAID i4 since release 2.00.4
Date: Tue, 13 Feb 2007 16:36:56 -0600
Message-ID: <1171406217.3382.48.camel@mulgrave.il.steeleye.com>
References: <20070213092920.f0bafea0.akpm@linux-foundation.org>
	 <1171389557.3382.34.camel@mulgrave.il.steeleye.com>
	 <45D22F1C.7060604@ricospirit.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34732 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751378AbXBMWhP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2007 17:37:15 -0500
In-Reply-To: <45D22F1C.7060604@ricospirit.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Belhomme <rico@ricospirit.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

On Tue, 2007-02-13 at 22:35 +0100, Eric Belhomme wrote:
> hole:/home/rico# lsmod|grep megaraid
> megaraid_mbox          35368  0
> megaraid_mm            12068  1 megaraid_mbox
> megaraid               41704  1
> scsi_mod              151980  7 
> megaraid_mbox,sr_mod,sd_mod,megaraid,sg,aic7xxx,scsi_transport_spi
> ho
> 
> So if I understand well, the module actively used with the LSI card is 
> megaraid, the legacy one ! but the mbox and mm are loaded and seems to 
> be necessary for the legacy driver ?

Actually, it shouldn't be.  megaraid_mbox depends on megaraid_mm as your
lsmod shows, which is correct.  However, nothing's depending on legacy
megaraid ... I'm not sure why it's showing as loaded and in use.

James


