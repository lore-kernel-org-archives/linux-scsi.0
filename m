From: James Bromberger <jbromberger@fotango.com>
Subject: Sym/LSI 53C1010-66 and 2.5.75/2.6.0-t1
Date: 14 Jul 2003 15:19:42 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058192382.8933.35.camel@phoenix>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.fotango.com ([195.157.53.90]:43150 "EHLO mx1.fotango.com")
	by vger.kernel.org with ESMTP id S270609AbTGNOI4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2003 10:08:56 -0400
Received: from dhcp-client-37.dev-fotango.com (localhost.localdomain [127.0.0.1])
	by mx1.fotango.com (8.12.9/8.12.8) with ESMTP id h6EECneR020551
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2003 15:12:49 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hey all,

I have a DNUK box here with a 53C1010-66 card in it; works fine with the
2.4.18 sym53c8xx driver, but when trying to use either the SYM53C8XX or
SYM53C8XX_2 drivers from the late 2.5 series (and now 2.6.0-test1) it
fails to be detected. 

The card BIOS reports to be 'Symbios v4.0 PIC Rev 2.0, 2.1, (c) LSI
Corp, PCI-4.19.00'. It looks like firmware 4.19.00 is the latest from
LSI for this hardware (released around 2001).

Can anyone point me in the right direction to get this working please? I
get a panic on boot since my root disk on this device, and it isn't
being recognised during boot (ie, kernel image loads (all static kernel,
no modules), and then panics when it tries to get to the root filesystem
on /dev/sda3 on the disk on this controller.

I have been reading archives of this list and lkml and can't see
anything related, but then again, I may have missed something.

TIA,

  James Bromberger
-- 
James Bromberger  |  jbromberger@fotango.com  |  www.james.rcpt.to
Fotango Ltd, 32-37 Cowper Street, London, EC2A 4AW
Tel: +44 (0)207 251-7010 | Fax: +44 (0)207 608-3592 | Web: www.fotango.com

