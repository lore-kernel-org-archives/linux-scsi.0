From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Driver version for PMC Adaptec HBA in Linux and from vendor
Date: Fri, 17 Feb 2017 17:40:50 +0100
Message-ID: <f09c20d4-dd38-d619-3b31-7782f9b5c0de@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.molgen.mpg.de ([141.14.17.9]:53523 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934084AbdBQQkw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 11:40:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: linux-scsi@vger.kernel.org, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Thomas Kreitler <kreitler+lkml@molgen.mpg.de>

Dear Raghava, dear Linux folks,


Using a PMC Adaptec HBA 1000-8e with latest Linux, it only initializes 
in sync mode, instead of async mode.

```
$ git describe --tag
v4.10-rc8-47-g0722f57bf
$ dmesg
[   21.359635] Adaptec aacraid driver 1.2-1[41066]-ms
[   21.360017] aacraid 0000:04:00.0: can't disable ASPM; OS doesn't have 
ASPM control
[   21.363987] AAC0: Async. mode not supported by current driver, sync. 
mode enforced.
[   21.363987] Please update driver to get full performance.
[   21.364949] AAC0: kernel 1.2-0[0] Nov  5 2015
[   21.365275] AAC0: monitor 0.0-0[0]
[   21.371382] AAC0: bios 0.13-209[32000]
[   21.371711] AAC0: serial 10F447
[   21.372035] AAC0: Non-DASD support enabled.
[   21.372360] AAC0: 64bit support enabled.
[   21.372688] AAC0: 64 Bit DAC enabled
[…]
$ git grep 'AAC_DRIVER_BUILD 41066'
drivers/scsi/aacraid/aacraid.h:# define AAC_DRIVER_BUILD 41066
```

Searching the vendor Web site, there is *Linux Driver Source 
1.2.1-53005* available for download [1].

How does the upstream process work? Is there a git repository somewhere 
from Microsemi? Are the patches already up for review? (I didn’t find them.)

The answers would be very helpful for our evaluation of the device.


Kind regards,

Paul


[1] 
https://storage.microsemi.com/en-us/speed/raid/aac/linux/aacraid-linux-src-1_2_1-53005_tgz.php
