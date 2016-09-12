From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: TRIM/UNMAP/DISCARD via ATA Passthrough
Date: Mon, 12 Sep 2016 20:50:22 +0200
Message-ID: <CAHmME9q4TV4EVAK-4X8Fx9x_YYT3fh4zbtQgjnFR4ut7dTUUfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi folks,

There's a huge quantity of USB enclosures flooding the market for
quite sometime that support UASP, which is very nice. This allows for
higher speeds by using the SCSI command set via the uas driver, and
offers various other advantages over the classic usb-storage driver.

These USB enclosures do not support SCSI UNMAP. However, they do
support ATA-passthrough, and `hdparm -I` shows that TRIM is supported.

I was wondering if it'd be possible to have the uas driver -- or
perhaps somewhere else in the stack -- fall back to using
ATA-passthrough-TRIM for UNMAP, so that discard can work properly.
AFAIK, the Windows drivers do exactly this.

If the answer is, "yes we want this! but we don't have the man power,"
please tell me where I can start looking, so that I can submit the
patch myself.

Thanks,
Jason
