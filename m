From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] qlogicpti: use request_firmware
Date: Sat, 10 Jan 2009 19:19:10 +0000
Message-ID: <1231615150.5806.137.camel@macbook.infradead.org>
References: <1231600926.5806.131.camel@macbook.infradead.org>
	 <1231603097.3642.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:55885 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbZAJTTe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jan 2009 14:19:34 -0500
In-Reply-To: <1231603097.3642.25.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, jaswinder@infradead.org

On Sat, 2009-01-10 at 09:58 -0600, James Bottomley wrote:
> I'm assuming this fixes the open firmware conversion bug?

Which bug was that?

> What about the missing Kconfig piece?  FW_LOADER must be selected
> otherwise you can build a config where the device can't possibly work.

I thought we'd started off doing that, but then removed it again;
someone went on a crusade _removing_ 'select FW_LOADER' from drivers
which use request_firmware().

I think the logic was that you can only turn off FW_LOADER if you define
CONFIG_EMBEDDED anyway... although I was never quite sure why that
mattered. We can do it either way; I don't really care.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

