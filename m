From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: mptbase Code={Abort}
Date: Mon, 14 Apr 2008 07:29:37 +1200
Message-ID: <48025F21.8000107@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.sauce.co.nz ([210.48.49.72]:41527 "EHLO smtp.sauce.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbYDMT2j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Apr 2008 15:28:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

A "me too" here as well.

Fedora 8 x86_64 2.6.24.4-64.fc8, 8GB RAM, LSI SAS1068 B1 with latest 
BIOS and FW, attached to 15 x WD7500AYYS SATA via a Vitesse port expander.

While doing initial sync up on an md RAID 5 of the first eight drives:

Apr 13 13:53:16 flash2 kernel: mptbase: ioc0: LogInfo(0x31123000): 
Originator={PL}, Code={Abort}, SubCode(0x3000)
Apr 13 13:53:18 flash2 kernel: mptbase: ioc0: LogInfo(0x31120403): 
Originator={PL}, Code={Abort}, SubCode(0x0403)
Apr 13 13:53:21 flash2 kernel: mptbase: ioc0: LogInfo(0x31123000): 
Originator={PL}, Code={Abort}, SubCode(0x3000)
Apr 13 13:53:21 flash2 kernel: mptbase: ioc0: LogInfo(0x31120403): 
Originator={PL}, Code={Abort}, SubCode(0x0403)
Apr 13 13:53:23 flash2 kernel: mptbase: ioc0: LogInfo(0x31123000): 
Originator={PL}, Code={Abort}, SubCode(0x3000)
Apr 13 13:53:24 flash2 kernel: mptbase: ioc0: LogInfo(0x31120403): 
Originator={PL}, Code={Abort}, SubCode(0x0403)
Apr 13 13:53:34 flash2 kernel: mptbase: ioc0: LogInfo(0x31123000): 
Originator={PL}, Code={Abort}, SubCode(0x3000)
Apr 13 13:53:34 flash2 kernel: mptbase: ioc0: LogInfo(0x31120403): 
Originator={PL}, Code={Abort}, SubCode(0x0403)
Apr 13 13:53:36 flash2 kernel: mptbase: ioc0: LogInfo(0x31123000): 
Originator={PL}, Code={Abort}, SubCode(0x3000)
Apr 13 13:53:38 flash2 kernel: mptbase: ioc0: LogInfo(0x31120403): 
Originator={PL}, Code={Abort}, SubCode(0x0403)
Apr 13 13:53:42 flash2 kernel: mptbase: ioc0: LogInfo(0x31123000): 
Originator={PL}, Code={Abort}, SubCode(0x3000)
Apr 13 13:53:42 flash2 kernel: mptbase: ioc0: LogInfo(0x31120403): 
Originator={PL}, Code={Abort}, SubCode(0x0403)
Apr 13 13:53:44 flash2 kernel: mptbase: ioc0: LogInfo(0x31123000): 
Originator={PL}, Code={Abort}, SubCode(0x3000)
Apr 13 13:53:46 flash2 kernel: mptbase: ioc0: LogInfo(0x31120403): 
Originator={PL}, Code={Abort}, SubCode(0x0403)
Apr 13 13:53:50 flash2 kernel: mptbase: ioc0: LogInfo(0x31123000): 
Originator={PL}, Code={Abort}, SubCode(0x3000)

Will try compiling latest mpt fusion driver today.

Have sent a similar mail, including lsiutil dump offlist to eric at LSI.

Regards,

Richard
