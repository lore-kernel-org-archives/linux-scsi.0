From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14214] BUG at drivers/scsi/scsi_lib.c:1108!
Date: Thu, 1 Oct 2009 09:02:35 GMT
Message-ID: <200910010902.n9192ZMU007722@demeter.kernel.org>
References: <bug-14214-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41190 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbZJAJCb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 05:02:31 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9192ZBp007723
	for <linux-scsi@vger.kernel.org>; Thu, 1 Oct 2009 09:02:35 GMT
In-Reply-To: <bug-14214-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14214





--- Comment #6 from Plamen Petrov <pvp-lsts@fs.ru.acad.bg>  2009-10-01 09:02:34 ---
Some of the notable differences between the bad and good .config are:
good had CONFIG_SLOW_WORK=y;
IO schedulers: bad used CONFIG_DEFAULT_DEADLINE=y while good is with
CONFIG_DEFAULT_NOOP=y
bad had CONFIG_X86_MPPARSE=y, where good does not;
good has CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y, bad didn't;
bad had CONFIG_HOTPLUG_CPU=y, good does not;
I did not list the new config options which 2.6.32-rc1 has, and 2.6.31-git12
does not;

NOTE: these are both SMP enabled configs;

I will try and build 2.6.32-rc1 with the exact same config I used with
2.6.31-git12 to see how it fares, so we will know if the problem was fixed in
2.6.32-rc1; I will use gcc 4.4.1, though, and the kernel which did not allow me
to reboot or shutdown was built with gcc 4.3.3.

Thanks!

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
