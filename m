From: "Pascal Terjan" <pterjan@gmail.com>
Subject: Re: [Bugme-new] [Bug 11792] New: Oops when reading /proc/megaraid/hba0/diskdrives-ch*
Date: Tue, 21 Oct 2008 22:22:37 +0200
Message-ID: <e8ca35370810211322s42f87392o5259353af8a25323@mail.gmail.com>
References: <bug-11792-10286@http.bugzilla.kernel.org/>
	 <20081021124701.3d639c4e.akpm@linux-foundation.org>
	 <20081021195419.GR26184@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:63433 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbYJUUWi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2008 16:22:38 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2663720wfd.4
        for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2008 13:22:37 -0700 (PDT)
In-Reply-To: <20081021195419.GR26184@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, sumantp@lsil.com, bo.yang@lsi.com, bugme-daemon@bugzilla.kernel.org

On Tue, Oct 21, 2008 at 9:54 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Tue, Oct 21, 2008 at 12:47:01PM -0700, Andrew Morton wrote:
>> > Latest working kernel version: 2.6.24
>> > Earliest failing kernel version: 2.6.27-rc8
>>
>> It's a regression.
>>
>> > Pid: 2319, comm: diff Not tainted (2.6.27-server-0.rc8.2mnb #1)
>
> It's also a distro kernel by the looks of things.  Can it be reproduced
> with an upstream kernel?

I will try booting the server on vanilla kernel but I'm not sure when
(we already rebooted it 2 times recently and users won't enjoy it).

This is a distro kernel but I don't see patches that could impact this :
http://svn.mandriva.com/cgi-bin/viewvc.cgi/packages/cooker/kernel/current/PATCHES/patches/

Machine is a old HP NetServer LT 6000

04:03.1 I2O: Intel Corporation 80960RP (i960RP) Microprocessor (rev
09) (prog-if 01)
	Subsystem: Hewlett-Packard Company MegaRAID, Integrated NetRAID
	Flags: bus master, fast Back2Back, medium devsel, latency 64, IRQ 11
	Memory at f4000000 (32-bit, prefetchable) [size=64M]
	[virtual] Expansion ROM at a8130000 [disabled] [size=32K]
	Capabilities: [80] Power Management version 2
	Kernel driver in use: megaraid_legacy
	Kernel modules: i2o_core, megaraid
