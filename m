From: "Bailey, Scott" <scott.bailey@eds.com>
Subject: RE: Qlogic ISP 1020
Date: Fri, 5 Nov 2004 14:20:15 -0500
Message-ID: <1CF4FE310DCDD3119A1F00508BDF0A6823C3E0A9@usahm019.exmi01.exch.eds.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ahmler5.mail.eds.com ([192.85.154.70]:49868 "EHLO
	ahmler5.mail.eds.com") by vger.kernel.org with ESMTP
	id S261170AbUKETV1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Nov 2004 14:21:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Ingvar Hagelund' <ingvar@linpro.no>, Christoph Hellwig <hch@lst.de>
Cc: "Bailey, Scott" <scott.bailey@eds.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

To recap, I have a 3-processor Alphaserver 4100 5/466 with several KZPBA-BA
(ISP1020A-based) SCSI controllers that runs Debian Linux on top of LVM on
top of md RAID-1 devices. I've been patching the feral driver into my kernel
but on the lookout for something easier to maintain.

Christoph developed a patch for the qla1280 driver (under 2.6) that
introduced support for ISP1020/ISP1040 devices; Ingvar brought this to my
attention and provided patches to backport this support to 2.4. These are
available at http://users.linpro.no/ingvar/alpha/qla1280/ for those coming
late to this party. :-)

I tried building a kernel from the Debian 2.4.27 kernel source with these
patches included; on 3 separate attempts, my system would lock up part-way
through the boot process.

Following up on a last suggestion from Ingvar, I rebuilt my 2.4.27 kernel
with CONFIG_SMP turned off.

It wasn't a huge test, but I was able to boot my system cleanly without any
problems. That's much farther than I got running the SMP-enabled kernel.

Therefore I conclude that either I am the first person in the universe to
use the 2.4 qla1280 driver on a multiprocessor Alpha system, or the ISP10x0
support patch somehow is not SMP-safe (at least as backported).

I am happy and eager to do more playtesting if anybody has more suggestions,
requests for additional information, or revised patches appear. (As I
mentioned before, I am clueless about using magic SYSRQ keys on an
Alphaserver with a serial console.)

Tantalized,

	Scott
