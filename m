From: "Zhao, Forrest" <forrest.zhao@intel.com>
Subject: RE: One question about SCSI device hotplug
Date: Wed, 2 Mar 2005 13:33:05 +0800
Message-ID: <8126E4F969BA254AB43EA03C59F44E84018500DC@pdsmsx404>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from fmr19.intel.com ([134.134.136.18]:11976 "EHLO
	orsfmr004.jf.intel.com") by vger.kernel.org with ESMTP
	id S262184AbVCBFev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2005 00:34:51 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: James.Smart@Emulex.Com, matthew@wil.cx, linux-scsi@vger.kernel.org, "Caushik, Ramesh" <ramesh.caushik@intel.com>, sdake@mvista.com

<Exactly.  Some controllers know, and assert events up to their LLDD.
<Jame's Emulex driver apparently does, perhaps this holds true for all
<FC devices.

<Some firmwares (LSI megaraid for sure, Adaptec SCSI I believe) don't.

Thank you, Matt. Then I have another question:
As we know SCSI mid-layer issue a command to LLDD by 
host->hostt->queuecommand(cmd, scsi_done); and in the meantime a 
timer is set. When the timer expires, SCSI mid-layer know the 
execution of command has failed.
My question is: when SCSI device is surprise-removed, if SCSI mid-layer
issue a command to this removed device, will mid-layer has to wait 
a timeout before it can know the execution of command failed? Or is
there
any other mechanism that LLDD can notify mid-layer that execution of
command failed without waiting for a timeout?

Thanks,
Forrest
