From: Rick Warner <rick@microway.com>
Subject: errors from mptsas
Date: Tue, 8 Apr 2008 18:20:19 -0400
Message-ID: <200804081820.19607.rick@microway.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.microway.com ([64.80.227.22]:51898 "EHLO microway.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752137AbYDHWyy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Apr 2008 18:54:54 -0400
Received: from herp.microway.com (warden.microway.com [64.80.227.66])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by microway.com (Postfix) with ESMTP id 676E82216
	for <linux-scsi@vger.kernel.org>; Tue,  8 Apr 2008 18:20:20 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I am working on 2 dual opteron systems using LSI 3041E SAS cards (1064E(b3)).  
They each have (1) 73G Seagate SAS drive and (2) 750G Seagate SATA drives 
hooked up to them.

One of the stress tests we run on systems is looping through the hard drives 
running "dd if=/dev/sdX of=/dev/null". With that running, we get a steady 
stream of these errors in the dmesg-

mptbase: ioc0: LogInfo(0x31123000): Originator={PL}, Code={Abort}, 
SubCode(0x3000)

Any idea what's going on here? I have already updated to the latest firmware 
for the card.  The system is loaded with FC8 running 2.6.24.4-64.fc8.

Right now, I have 
Thanks,
Rick

-- 
Richard Warner
Lead Systems Integrator
Microway, Inc
(508)732-5517
