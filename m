From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: SuSE hwinfo/yast2 still confusing SYM53C8XX, killing tape backups
Date: Mon, 29 Nov 2004 12:24:17 +0100
Message-ID: <m34qj8290e.fsf@merlin.emma.line.org>
References: <4197E4B7.3050008@pobox.com> <1100473795.23649.26.camel@mulgrave>
	<m3hdnsvvfd.fsf@merlin.emma.line.org>
	<1100477105.24921.3.camel@mulgrave>
	<m34qjrx6iy.fsf_-_@merlin.emma.line.org>
	<Pine.LNX.4.61.0411221102280.22230@ligeti.suse.de>
	<m3actaw0pv.fsf@merlin.emma.line.org>
	<20041122133014.GF25636@parcelfarce.linux.theplanet.co.uk>
	<m3mzxaq8ra.fsf@merlin.emma.line.org>
	<Pine.LNX.4.61.0411261512320.14112@ligeti.suse.de>
	<20041127004000.GA23180@merlin.emma.line.org>
	<Pine.LNX.4.61.0411291209220.24675@ligeti.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.E-Technik.Uni-Dortmund.DE ([129.217.163.1]:39323 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S261680AbUK2LYV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Nov 2004 06:24:21 -0500
In-Reply-To: <Pine.LNX.4.61.0411291209220.24675@ligeti.suse.de> (Steffen
	Winterfeldt's message of "Mon, 29 Nov 2004 12:16:42 +0100 (CET)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Winterfeldt <snwint@suse.de>
Cc: Matthias Andree <matthias.andree@gmx.de>, Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Steffen Winterfeldt <snwint@suse.de> writes:

>> The hwinfo-8.70-0.2 update alone doesn't appear to help, I still see parity
>> errors and still see 256-byte reads from
>> /sys/devices/pci0000:00/0000:00:0d.0/config (my SYM53C875's config space),
>> strace below
>
> They are from /sbin/raiddetect (same cause as in hwinfo - libsysfs
> usage).

And also in the udev package... will we see an updated udev package for
SL 9.1 and 9.2, perhaps as Driver or Vendor Update, so it can help at
first install already? These SYM53C8XX adaptors are quite popular.

>> The kernel (vanilla 2.6.9) still begs that hwinfo be converted to SG_IO.
>
> That warning was introduced after SL 9.1 was finished.

Yes indeed, but SG_IO has been around for ages - but as you'd written
the SL 9.2 version had already been converted, this might be a good time
to fix it for 9.1, too. The package needs to be patched anyways.

-- 
Matthias Andree
