From: "Eric Raskin" <eraskin@paslists.com>
Subject: How to disconnect a SCSI device without crashing SLES8?
Date: Fri, 4 Feb 2005 14:12:13 -0500
Message-ID: <156801c50aed$2348aee0$650aa8c0@ehrpc>
Reply-To: <eraskin@paslists.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from paslists.com ([12.170.105.210]:61638 "EHLO fw.paslists.com")
	by vger.kernel.org with ESMTP id S265047AbVBDTKj convert rfc822-to-8bit
	(ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2005 14:10:39 -0500
Received: from ehrpc (ehrpc.paslists.com [192.168.10.101])
	by fw.paslists.com (8.12.8/8.12.8) with ESMTP id j14JAPo8002381
	for <Linux-scsi@vger.kernel.org>; Fri, 4 Feb 2005 14:10:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-scsi@vger.kernel.org

Hello all:

I apologize in advance if this is the wrong forum for this question.  Please
feel free to direct me to the correct newgroup.

I have a Dell 6650 running Suse Enterprise 8 (SLES8) with the 2.4.21-138-smp
kernel.  I have a Quantum M1500 tape library with 2 SDLT220 tape drives
connected to one of the internal Adaptec Controllers using the aic7xxxx
driver.  One of the tape drives has failed.  From experience, and from
Quantum tech support, I know that turning off the library while the system
is up will crash Linux.

In searching the web, I've found the "remove-scsi-device" and
"add-scsi-device" commands that can be sent to /proc/scsi/scsi.

Does anybody know if the system will stay up if I use these commands to
remove all my tape library devices before shutting it down?  Is this the
proper way to repair my library without having to shut the system off?

TIA

  Eric Raskin

PS.  Dell wants to charge me $199 to get an answer to speak with the
engineers who can answer this question.  It's easier to just turn off the
system! :-/

----------------------------------------------------------------------------
Eric H. Raskin                                          Voice: 914-765-0500
Professional Advertising Systems Inc.                   Fax:   914-765-0503
200 Business Park Dr Suite 107                          eraskin@paslists.com
Armonk, NY 10504



