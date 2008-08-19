From: Jim Lester <Jim.Lester@compellent.com>
Subject: Switch root failing on boot
Date: Tue, 19 Aug 2008 10:50:37 -0500
Message-ID: <A7519D7FDEF2A144BA6D40BDF13100FEFEF1C6@ex2.Beer.Town>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.compellent.com ([76.164.8.134]:42457 "EHLO
	mail.compellent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbYHSP4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Aug 2008 11:56:17 -0400
Content-Class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a hand full of Red Hat servers that are booting from SAN using
QLogic fibre cards (QLA2462) and a Cisco fabric. 

They had been running fine for months. Now, more often than not, they
kernel panic on boot after it attempts to switch from the RAM disk to
the disk. 

The volumes are there because the QLogic BIOS is finding them and the
system is loading and executing Grub. But something happens with the
QLogic driver where it does not recognize the root volume, thus it
fails. 

Can anybody shed any light on where I should be looking to get this
solved? I don't know if this is a Red Hat, a QLogic, a Cisco problem,
what. If I can just get any info, pointers, debug info, anything.
Thanks. 

---
Jim Lester | Linux Product Specialist
Jim.Lester@Compellent.com
(o) 952.294.2802
(c) 763.218.6012
Compellent Technologies | www.compellent.com


