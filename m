From: Marcin Nowakowski <marcin.nowakowski.000@gmail.com>
Subject: continuous 'Test WP failed, assume Write Enabled' errors
Date: Tue, 4 Sep 2012 20:34:43 +0100
Message-ID: <CACdKh3FQGMLVSRErwcpQjty6uF9mi9n_VrrYj6X-v23nHkJ4TA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60164 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab2IDTen (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Sep 2012 15:34:43 -0400
Received: by pbbrr13 with SMTP id rr13so9979143pbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 04 Sep 2012 12:34:43 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

That's something that has been bothering me for a while but I hadn't
got to writing a question about it ...

I can see a stream of the following errors on my desktop


[233755.873770] sd 6:0:0:3: [sde] Test WP failed, assume Write Enabled
[233755.886450] sd 6:0:0:3: [sde] Asking for cache data failed
[233755.886455] sd 6:0:0:3: [sde] Assuming drive cache: write through
[233807.297205] sd 6:0:0:0: [sdb] Test WP failed, assume Write Enabled
[233807.309884] sd 6:0:0:0: [sdb] Asking for cache data failed
[233807.309890] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[233859.059886] sd 6:0:0:3: [sde] Test WP failed, assume Write Enabled
[233859.072563] sd 6:0:0:3: [sde] Asking for cache data failed
[233859.072569] sd 6:0:0:3: [sde] Assuming drive cache: write through
[233910.823178] sd 6:0:0:4: [sdf] Test WP failed, assume Write Enabled

(continues infinitely)

and also possibly related error when coming out of suspend state

[233714.179445] ata1: link is slow to respond, please be patient (ready=0)
[233718.792644] ata1: COMRESET failed (errno=-16)
[233719.821109] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[233719.961354] ata1.00: configured for UDMA/133
[233719.980924] sd 0:0:0:0: [sda] Starting disk
[233719.988158] PM: resume of devices complete after 11241.539 msecs
[233719.988206] PM: resume devices took 11.240 seconds
[233719.988207] ------------[ cut here ]------------
[233719.988211] WARNING: at kernel/power/suspend_test.c:53
suspend_test_finish+0x86/0x90()
[233719.988212] Hardware name: Aspire M3920
[233719.988213] Component: resume devices, time: 11240

I'm currently running Ubuntu 12.04 using an upstream kernel 3.5.

I'm not familiar with the scsi subsystem at all, but I can help anyone
familiar with such problems with debugging - and hopefully solving -
this problem.

thanks
Marcin
