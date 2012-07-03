From: Bing Zhao <bzhao@marvell.com>
Subject: RE: New Defects based on recent changes in Kernel code found by
 Coverity Scan
Date: Tue, 3 Jul 2012 16:05:12 -0700
Message-ID: <477F20668A386D41ADCC57781B1F7043083AA54EEC@SC-VEXCH1.marvell.com>
References: <829BE905228AE14A9AE1A46E6F2E371605538D039D@VA3DIAXVS891.RED001.local>
 <20120703152739.ea7df9e6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120703152739.ea7df9e6.akpm@linux-foundation.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Scan Subscription <scan-subscription@coverity.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Chris Mason <chris.mason@fusionio.com>, Robert Love <robert.w.love@intel.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Mattia Dongili <malattia@linux.it>, Matthew Garrett <mjg@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Andrew,

> > *. CID 709078: Resource leak (RESOURCE_LEAK) - drivers/net/wireless/mwifiex/cfg80211.c, line: 935
> > Assigning: "bss_cfg" = storage returned from "kzalloc(132UL, 208U)" - but was not free
> > drivers/net/wireless/mwifiex/cfg80211.c:935
> 
> bzhao

Just posted a patch (for 3.5) to fix this leak.

Thanks,
Bing
