From: Kevin K <k_krieser@sbcglobal.net>
Subject: SCSI selection issue with aic7xxx_old driver
Date: Wed, 29 Mar 2006 11:51:48 -0600
Message-ID: <F6783F90-89ED-4D3C-9D42-8F97D91907E0@sbcglobal.net>
Mime-Version: 1.0 (Apple Message framework v746.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:8545 "HELO
	smtp110.sbc.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750908AbWC2Rvv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 12:51:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm in the process up converting from RHEL 2.1 to RHEL 4, and have  
encountered an issue with the aic7xxx_old driver (5.2.6, as provided  
with the RH 2.4.9-34 kernel, and with 2.6.15.5 kernel).

  The SCSI card is an Adaptec 2940U card.

  Namely, an old SCSI device isn't being seen very often.  Maybe 1 in  
10 times loading the module.  Under the 2.4.18 kernel, it was always  
seen using this driver except in the case of hardware/cabling issues.

  With the same hardware and OS, but using the new driver (aic7xxx),  
the hardware is consistently seen.

  I've recompiled the module to enable VERBOSE debugging, and tried  
all 4 different seltime values, and it doesn't seem to matter what  
the seltime values are.  I still get selection timeouts.

  Any ideas?  I can provide debug logs from /var/log/messages.

If there is a better place to ask, let me know.

I didn't post this with Red Hat since it happens with a vanilla  
kernel too.

Kevin
