From: Michael <mozstuff@yahoo.com>
Subject: DAC960 + sym53c8xx conflict
Date: Sun, 15 Aug 2004 22:53:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092628387.2548.14.camel@fs2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp011.mail.yahoo.com ([216.136.173.31]:40579 "HELO
	smtp011.mail.yahoo.com") by vger.kernel.org with SMTP
	id S265102AbUHPEBd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 00:01:33 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've got a 4-processor Intel SC450NX-based system with motherboard
Sym53c896 dual controller driven a Mylex Acceleraid 200. The motherboard
also has a sym53c810a which drives a Sony SDT-9000 tape drive. This
combo has always worked well until I tried updating to a 2.6 kernel.

When I load 2.6 (tried 2.6. - 2.6.8-rc4 (mm tree too)) every works OK
until I load the sym53c8xx module. When that module is loaded all access
to the drives connected to the DAC960 vanishes. I get no errors and the
system is not locked up. Any attempt to access the disks on the DAC960
simply hangs.

Any ideas? I hacked teh sym driver to remove all support for the 896
chip, but it didn't.

-- 
Michael <mozstuff@yahoo.com>

