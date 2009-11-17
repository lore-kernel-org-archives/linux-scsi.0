From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Known-good PCI-E SAS HBAs?
Date: Tue, 17 Nov 2009 11:10:36 +0000
Message-ID: <73e903670911170310r3b4106eaxfd23c3195d8cb266@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:27910 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbZKQLKv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2009 06:10:51 -0500
Received: by qw-out-2122.google.com with SMTP id 3so1277903qwe.37
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2009 03:10:57 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi,

I'm looking for a 4-8 port PCI-Express SAS adapter that has solid
out-of-the-box Linux support. Can you give any recommendations?

I already have a PCI-e Supermicro AOC-SASLP-MV8 card that uses the
mvsas driver. It hasn't worked too well - when I start a mdadm raid
over it, the driver freaks out and drops the drives. This has been
documented in the mailing lists, and I believe there is a fix on the
way, but I haven't been able to obtain it despite trying.

I have seen recommendations for LSI PCI-e SAS adapters that also use
mvsas. However, I have also been told that sending SMART commands to
drives on these similarly cause the driver to freak out and drop
drives.

So, any recommendations for known fully-working PCI-Express SAS HBAs
with in-kernel support? 4-8 ports. Much appreciated.

FWIW, the Supermicro AOC-SAT2-MV8 PCI-X SATA card behaves perfectly. I
can highly recommend it, and would very much like to find something
similar but for PCI-e and SAS.

I'll be running relatively new kernels, 2.6.31, if it matters w.r.t.
driver support etc.

Thanks!

-- Kristleifur
