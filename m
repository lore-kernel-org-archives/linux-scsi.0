From: dth@cistron.nl (Danny ter Haar)
Subject: report: 2.6.14-rc2-git8 crashed with scsi error after 40 hours
Date: Sun, 2 Oct 2005 08:14:36 +0000 (UTC)
Message-ID: <dho4tc$ilc$1@news.cistron.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from news.cistron.nl ([62.216.30.38]:35238 "EHLO ncc1701.cistron.net")
	by vger.kernel.org with ESMTP id S1751014AbVJBIOh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Oct 2005 04:14:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Here is the more than weekly error report about our usenetgateway.
2.6.12-mm1 keeps running for weeks.
2.6.1[34] keeps crashing within days
Hardware isn't the problem, software is (my guess is acpi/irq)
ethernet is doing >200megabit/s average on 2 cards simultanious.

hardware:
tyan amd64 - opteron 250 (dual cpu, but UP kernel)
4Gig ram
dual scsi controller
8 x scsi disks
acenic gig-E (FO)
onboard gig-E (cupper)

software:
debian-pure64 amd


config/crash/dmesg @
http://newsgate.newsserver.nl/kernel/2.6.14-rc2-git8

Currently trying 2.6.14-rc2-mm2.
When that fails i will try rc3-git[latest]

Let me know when someone wants to have more info or a test
setup.

Danny

