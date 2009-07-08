From: Douglas Gilbert <dgilbert@interlog.com>
Subject: mptspi: Unexpected doorbell active!
Date: Wed, 08 Jul 2009 17:06:57 +0200
Message-ID: <4A54B611.2030802@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:50874 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405AbZGHPHD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2009 11:07:03 -0400
Received: from localhost (localhost [127.0.0.1])
	by elrond.infotech.no (Postfix) with ESMTP id 5B15730242
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2009 17:06:59 +0200 (CEST)
Received: from elrond.infotech.no ([127.0.0.1])
	by localhost (elrond.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WaSvSrx36+D2 for <linux-scsi@vger.kernel.org>;
	Wed,  8 Jul 2009 17:06:58 +0200 (CEST)
Received: from [82.134.31.166] (unknown [82.134.31.166])
	by elrond.infotech.no (Postfix) with ESMTPA id 1C85830345
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2009 17:06:58 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Cute error message but it appears just before my machine
locks solid. It looks like it is coming from a LSI 53c1030
SPI controller which lspci says is PCI-X but is actually
PCIe.

I get that with 2 different tape drives (LTO-1 and LTO-3)
whose true identities are hidden behind badge engineering,
Tandberg data perhaps? Anyway both seem to have a major
problem with the LOG SENSE command and the Tape Alert
page in particular.

The lockup occurs with both a Debian Lenny standard kernel
(lk 2.6.26-2-686) and a kernel.org lk 2.6.30 .

There is nothing other than the 53c1030 and a single tape
drive on the SCSI bus. So there is no good reason to lock
up the machine for any SCSI related error.

Doug Gilbert
