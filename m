From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [ANNOUNCE] multipath-tools-0.2.8
Date: Sat, 14 Aug 2004 13:59:25 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092484765.3571.17.camel@zezette>
References: <1090836168.4104d6c8a2b22@imp6-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.wanadoo.fr ([193.252.22.29]:43494 "EHLO
	mwinf0207.wanadoo.fr") by vger.kernel.org with ESMTP
	id S268663AbUHNL71 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Aug 2004 07:59:27 -0400
In-Reply-To: <1090836168.4104d6c8a2b22@imp6-q.free.fr>
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, Jan Kunigk <jan.kunigk@de.ibm.com>, linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools version 0.2.8

This is pre-vacation release, to sync up with guys working with the
priority framework.
I'll be mostly off till Sept 1st.

Reported build breakage on IA64 is not solved in this release. I don't
have the hw to investigate this. If someone is interested, feel free to
debug this and send a patch. The breakage seem to come from the clone
syscall declaration.

Todo, for next releases :

* move to the new klibc development environment Sam Ravnborg is working
on, as soon as it stabilizes : hope to drop the klibc tree from the
multipath-tools tarball, and finally be packageable by distributors.

* resolve the OOM scenarii for multipathd. I guess the kernel will have
to help in some way. Anyway, advice badly needed here.

2004-08-14 multipath-tools-0.2.8
        * [multipathd] setsched prio to RT
        * [multipath] massive include cleanup
        * [multipath] add a "default_prio_callout" keyword
          first user will be SPC-3 ALUA priority field fetcher
          from IBM
        * [multipath] reenable stdout on some error paths
        * [build] spilt KERNEL_DIR into KERNEL_SOURCE &
          KERNEL_BUILD as per 2.6 and SuSe convention
        * [klibc] kill warnings due to awk parsing wrong locale in
          arch/i386/MCONFIG
        * [multipath] implement a generic group_by_prio pgpolicy
        * [multipath] fix the broken failover pgpolicy

Downloads and docs at http://christophe.varoqui.free.fr

regards,
cvaroqui

