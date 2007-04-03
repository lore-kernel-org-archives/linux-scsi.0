From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Linux tape drivers
Date: Tue, 03 Apr 2007 17:15:41 -0500
Message-ID: <1175638541.3645.57.camel@mulgrave.il.steeleye.com>
References: <200704031508.37222.kern@sibbald.com>
	 <20070403133904.0029ccd2.akpm@linux-foundation.org>
	 <200704032330.16399.kern@sibbald.com>
	 <20070403145728.d8f83320.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45414 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946004AbXDCWQi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Apr 2007 18:16:38 -0400
In-Reply-To: <20070403145728.d8f83320.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kern Sibbald <kern@sibbald.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, Willem Riede <wrlk@riede.org>

On Tue, 2007-04-03 at 14:57 -0700, Andrew Morton wrote:
> If it's purely a driver problem then it's presumably not relevant to the
> scsi developers.  Raising a report at bugzilla.kernel.org would probably be
> appropriate - I will then route it to the appropriate developer (if any)
> and we'll at least know that we have an issue to be addressed.

Actually, that does depend on the kernel.  If it's a SATAPI device, then
it will be using the st driver.  Likewise, if it's one of the new PATA
things moved under drivers/ata, it should also be using st ... it's only
the legacy PATA devices that use ide-tape now.

Do we know what the kernel and device (and IDE controller) are?

James


