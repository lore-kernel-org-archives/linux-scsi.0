From: Andreas Moroder <andreas.moroder@sb-brixen.it>
Subject: persistent scsi with udev
Date: Thu, 08 Feb 2007 13:05:41 +0100
Message-ID: <eqf3li$9s7$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:43775 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422951AbXBHMJQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Feb 2007 07:09:16 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1HF82x-0000Qe-Uw
	for linux-scsi@vger.kernel.org; Thu, 08 Feb 2007 13:06:40 +0100
Received: from merlin2.provinz.bz.it ([62.101.0.30])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 08 Feb 2007 13:06:39 +0100
Received: from andreas.moroder by merlin2.provinz.bz.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 08 Feb 2007 13:06:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

we have a big problem with scsi device mapping.

We have a LSI Megaraid controller and a qlogic HBA with a attached SAN

When we boot the machine without the SAN then  the first disk on the 
MEGARAID becomes \dev\sda

When we boot with the SAN attached then the first disk in the san 
becomes \dev\sda and the system stop.

Is there a step by step tot availabe on how to configure the udev files 
when two SCSI devices are installed in one machine ?

Thanks
Andreas

