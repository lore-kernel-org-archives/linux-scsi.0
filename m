From: Steffen Winterfeldt <snwint@suse.de>
Subject: Re: SuSE hwinfo/yast2 still confusing SYM53C8XX, killing tape backups
Date: Mon, 29 Nov 2004 12:16:42 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411291209220.24675@ligeti.suse.de>
References: <4197E4B7.3050008@pobox.com> <1100473795.23649.26.camel@mulgrave>
 <m3hdnsvvfd.fsf@merlin.emma.line.org> <1100477105.24921.3.camel@mulgrave>
 <m34qjrx6iy.fsf_-_@merlin.emma.line.org> <Pine.LNX.4.61.0411221102280.22230@ligeti.suse.de>
 <m3actaw0pv.fsf@merlin.emma.line.org> <20041122133014.GF25636@parcelfarce.linux.theplanet.co.uk>
 <m3mzxaq8ra.fsf@merlin.emma.line.org> <Pine.LNX.4.61.0411261512320.14112@ligeti.suse.de>
 <20041127004000.GA23180@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from news.suse.de ([195.135.220.2]:43682 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S261666AbUK2LQw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Nov 2004 06:16:52 -0500
In-Reply-To: <20041127004000.GA23180@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <matthias.andree@gmx.de>
Cc: Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

On Sat, 27 Nov 2004, Matthias Andree wrote:

> Steffen Winterfeldt schrieb am 2004-11-26:
> 
> > It was indeed libsysfs reading the config space accidentally when one 
> > (well, I) wouldn't expect it to do this.
> > 
> > If you want to try the fixed hwinfo package (hwinfo-8.70), it's here:

[...]

> The hwinfo-8.70-0.2 update alone doesn't appear to help, I still see parity
> errors and still see 256-byte reads from
> /sys/devices/pci0000:00/0000:00:0d.0/config (my SYM53C875's config space),
> strace below

They are from /sbin/raiddetect (same cause as in hwinfo - libsysfs usage).

> The kernel (vanilla 2.6.9) still begs that hwinfo be converted to SG_IO.

That warning was introduced after SL 9.1 was finished.


Steffen
