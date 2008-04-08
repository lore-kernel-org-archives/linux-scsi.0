From: Bernd Schubert <bs@q-leap.de>
Subject: Re: mptsas and ioc0: ERRORs
Date: Tue, 8 Apr 2008 20:10:43 +0200
Message-ID: <200804082010.44090.bs@q-leap.de>
References: <20080407104940.5c7c89d1.taeuber@bbaw.de> <0631C836DBF79F42B5A60C8C8D4E8229F79FF7@NAMAIL2.ad.lsil.com> <20080408093858.5ea6f2ed.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:34608 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbYDHSKq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Apr 2008 14:10:46 -0400
In-Reply-To: <20080408093858.5ea6f2ed.taeuber@bbaw.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lars =?utf-8?q?T=C3=A4uber?= <taeuber@bbaw.de>
Cc: linux-scsi@vger.kernel.org, Wakko Warner <wakko@animx.eu.org>



> Yesterday the machine failed again. But now I run a kernel with Roberts
> patch: Apr  7 18:37:38 monosan kernel: sd 6:0:18:0: Bernd, check this: scmd
> retry 1/9 Apr  7 18:37:38 monosan kernel: sd 6:0:18:0: Activating scsi

Oops, damn, I mixed up the patch directories. I removed the "Bernd, check 
this" message already some time ago. This was just helping me to better 
understand the problem. And the patch series having this statement was just 
for internal debugging usage, but is not suitable for general usage.

http://www.pci.uni-heidelberg.de/tc/usr/bernd/downloads/scsi/2.6.22-eh-patches-v2.tar.bz2

I just uploaded the recent version. Please use this, as it does have more 
suitable debugging output.


Sorry for this,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
