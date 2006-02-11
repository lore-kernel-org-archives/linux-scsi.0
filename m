From: Andreas Kirchhofer <akirchhofer@acm.org>
Subject: Problems with aic7xxx - starting with Kernel 2.6.13
Date: Sat, 11 Feb 2006 22:04:09 +0100
Message-ID: <1139691849.3048.12.camel@idefix.kirchhofers-home.de>
Reply-To: andreas@kirchhofers-home.de
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.183]:58083 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S932354AbWBKVEM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Feb 2006 16:04:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

hope I'm in the right list...

I've a Asus P2B-DS with 2 PIII and an on-board aic7xxx SCSI controller
chip. I use KDE and k3b for burning CDs and DVDs... the distribution I
use is an up-to-date Fedora Core 4.

Starting k3b on a 2.6.15 kernel it starts to search for CD devices and
than I get some kernel-smp-aipc and so on messages in my console, load
increases to 20 and 30 and than - kernel panic!

The same is with any kernel I tried starting from 2.6.13... I used other
distribs like Knoppix and Kanotix too... it was the same with kernels
greater than 2.6.12.

If I boot my system with a 2.6.12 kernel (the remaining software the
same) k3b works without any kind of trouble...

So I'm quite lost at the moment - it seems to be a problem with the
newer 2.6 kernels and aic7xxx...

Does anybody in this list might have a glue of what's going on and how
to patch it?

Thanks a lot in advance,

cheers,

Andreas

