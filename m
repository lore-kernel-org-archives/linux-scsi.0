From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: [PROBLEM] reproduceable storage errors on high IO load - mvsas
 & 3.0-rc7
Date: Wed, 27 Jul 2011 10:26:24 +0200
Message-ID: <20110727102624.971cc287.taeuber@bbaw.de>
References: <20110606095127.21d23a70.taeuber@bbaw.de>
	<201106060559.03131.gene.heskett@gmail.com>
	<20110606130628.e86f0c67.taeuber@bbaw.de>
	<201106060920.32257.gene.heskett@gmail.com>
	<20110606155610.69a0d17a.taeuber@bbaw.de>
	<20110607124354.06ed074e.taeuber@bbaw.de>
	<20110701102323.3db579ad.taeuber@bbaw.de>
	<20110701151313.2afd48e0.taeuber@bbaw.de>
	<20110701163719.27afc580.taeuber@bbaw.de>
	<20110704153923.b929ce5d.taeuber@bbaw.de>
	<62378.1309905287@turing-police.cc.vt.edu>
	<20110706091117.9caa1d69.taeuber@bbaw.de>
	<20110714111642.83335f2a.taeuber@bbaw.de>
	<20110714123012.92787569.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110714123012.92787569.taeuber@bbaw.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello again!

This is an update for those who are interested.

I could find a hardware setup whith which the problems don't occur.
I exchanged the Supermicro H8SCM-F (AMD Opteron 4170HE) board with one with an
Intel CPU.

So it might be the chipset or the like.

All previous tested HBAs and SATA controller run just fine without any
strange messages on the intel based board.

The last try with the supermicro board was with an LSI SAS1068E PCI-Express
Fusion-MPT SAS HBA. It doesn't crash but did resets on the SATA connection
all the time. I could get 5,1MB write speed at most.

Best regards
Lars
