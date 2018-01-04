From: Vinson Lee <vlee@freedesktop.org>
Subject: HP ProLiant DL360p Gen8 hangs with Linux 4.13+.
Date: Thu, 4 Jan 2018 14:32:00 -0800
Message-ID: <CACKvgLEtPRpAS58kn-Skjn65-ZkDK17_cE+OzJodxQ=XvtQPGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:38125 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752344AbeADWcm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jan 2018 17:32:42 -0500
Received: by mail-oi0-f51.google.com with SMTP id r65so2019323oie.5
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jan 2018 14:32:41 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Don Brace <don.brace@microsemi.com>

Hi.

HP ProLiant DL360p Gen8 with Smart Array P420i boots to the login
prompt and hangs with Linux 4.13 or later. I cannot log in on console
or SSH into the machine. Linux 4.12 and older boot fine.

I see these messages on the console.

[  242.843206] INFO: task scsi_eh_2:465 blocked for more than 120 seconds.
[  242.877835]       Not tainted 4.15.0-041500rc6-generic #201712312330
[  242.909228] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  242.945404] INFO: task xfsaild/sda2:625 blocked for more than 120 seconds.
[  242.945407]       Not tainted 4.15.0-041500rc6-generic #201712312330
[  242.945410] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  242.945896] INFO: task kworker/u130:4:1023 blocked for more than 120 seconds.
[  242.945897]       Not tainted 4.15.0-041500rc6-generic #201712312330
[  242.945897] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  242.946449] INFO: task modprobe:1550 blocked for more than 120 seconds.
[  242.946450]       Not tainted 4.15.0-041500rc6-generic #201712312330
[  242.946450] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  242.946943] INFO: task postfix:1704 blocked for more than 120 seconds.
[  242.946946]       Not tainted 4.15.0-041500rc6-generic #201712312330
[  242.946948] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  242.947429] INFO: task (xinit.sh):1989 blocked for more than 120 seconds.
[  242.947432]       Not tainted 4.15.0-041500rc6-generic #201712312330
[  242.947434] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  363.674387] INFO: task scsi_eh_2:465 blocked for more than 120 seconds.
[  363.707741]       Not tainted 4.15.0-041500rc6-generic #201712312330
[  363.738601] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  363.774098] INFO: task xfsaild/sda2:625 blocked for more than 120 seconds.
[  363.804996]       Not tainted 4.15.0-041500rc6-generic #201712312330
[  363.833565] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  363.869380] INFO: task kworker/u130:4:1023 blocked for more than 120 seconds.
[  363.901795]       Not tainted 4.15.0-041500rc6-generic #201712312330
[  363.930403] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  363.966228] INFO: task modprobe:1550 blocked for more than 120 seconds.
[  363.966231]       Not tainted 4.15.0-041500rc6-generic #201712312330
[  363.966233] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.

Cheers,
Vinson
