From: Lester Hightower <hightowe@10east.com>
Subject: [FEATURE REQUEST] megaraid2 driver
Date: Wed, 21 Apr 2004 10:09:05 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0404210952220.29661@les5.10east.com>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC510@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from docs1.10east.com ([63.238.77.220]:42463 "EHLO 10east.com")
	by vger.kernel.org with ESMTP id S262874AbUDUOJL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 10:09:11 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC510@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Atul / readers of linux-scsi,

I am a very long time user of DCA960-based Mylex raid controllers; we have
dozens of them in our servers.  In fact, I have even tied u320 disks to
u160 Mylex controllers in recent years due to how stable both the cards
and Linux drivers are.  Recently we purchased a couple of LSI MegaRaid
cards and are starting to get our feet wet with those cards and the
megaraid2 Linux driver.

Yesterday we ran a test where we pulled a drive from a logical drive set
that had a hot spare.  The MegaRaid card rebuilt automatically, and after
we inserted a fresh disk it automatically marked as a hot spare.  That
went well, however, it took almost two hours to rebuild 73G on u320 disks
in raid-1, which surprised me since the Mylex Acceleraid 170 (u160) took
less than an hour in the same test.  I'm not complaining about the speed,
however, but making a feature request.

One thing the DAC960 driver does is publish the real-time progress of a
rebuild operation, both in /proc and by klog every few minutes.  The Linux
MegaRaid driver is completely silent start to finish, only showing that it
is in a Rebuild state.  Because the DAC960 card had already given us an
idea of how much time to expect the rebuild to take, the second hour that
the MegaRaid consumed was unnerving, and primarily due to the fact that we
had no rebuild progress indication available to us.

I searched through all of the structs in megariad2.h and do not readily
see any data available that would indicate the progress of a rebuild, else
I would code this myself and submit a patch.  Instead I am asking Atul,
and anyone else with expertise in this area, for assistance or advice in
implementing that feature.

Thanks,

--
Lester Hightower
