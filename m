From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] qlogicpti: use request_firmware
Date: Sat, 10 Jan 2009 09:58:17 -0600
Message-ID: <1231603097.3642.25.camel@localhost.localdomain>
References: <1231600926.5806.131.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58762 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204AbZAJP6U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2009 10:58:20 -0500
In-Reply-To: <1231600926.5806.131.camel@macbook.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, jaswinder@infradead.org

On Sat, 2009-01-10 at 15:22 +0000, David Woodhouse wrote:
> From: Jaswinder Singh <jaswinder@infradead.org>
> 
> Firmware blob is little endian
> 
> Thanks to Stephen Rothwell for fixing typos
> 
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> ---
>  drivers/scsi/qlogicpti.c         |   63 ++-
>  drivers/scsi/qlogicpti_asm.c     | 1160 --------------------------------------
>  firmware/Makefile                |    1 +
>  firmware/WHENCE                  |   10 +
>  firmware/qlogic/isp1000.bin.ihex | 1158 +++++++++++++++++++++++++++++++++++++
>  5 files changed, 1210 insertions(+), 1182 deletions(-)
>  delete mode 100644 drivers/scsi/qlogicpti_asm.c
>  create mode 100644 firmware/qlogic/isp1000.bin.ihex

I'm assuming this fixes the open firmware conversion bug?

What about the missing Kconfig piece?  FW_LOADER must be selected
otherwise you can build a config where the device can't possibly work.

James


