From: Steffen Winterfeldt <snwint@suse.de>
Subject: Re: SuSE hwinfo/yast2 still confusing SYM53C8XX, killing tape backups
Date: Fri, 26 Nov 2004 15:16:55 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411261512320.14112@ligeti.suse.de>
References: <1100467267.23710.7.camel@mulgrave> <4197E4B7.3050008@pobox.com>
 <1100473795.23649.26.camel@mulgrave> <m3hdnsvvfd.fsf@merlin.emma.line.org>
 <1100477105.24921.3.camel@mulgrave> <m34qjrx6iy.fsf_-_@merlin.emma.line.org>
 <Pine.LNX.4.61.0411221102280.22230@ligeti.suse.de> <m3actaw0pv.fsf@merlin.emma.line.org>
 <20041122133014.GF25636@parcelfarce.linux.theplanet.co.uk>
 <m3mzxaq8ra.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:62401 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S262363AbUKZTV4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Nov 2004 14:21:56 -0500
Received: from Cantor.suse.de (cantor.suse.de [195.135.220.2])
	by zeus.kernel.org (8.12.11/8.11.6) with ESMTP id iAQEI5rL027668
	for <linux-scsi@vger.kernel.org>; Fri, 26 Nov 2004 06:18:09 -0800
In-Reply-To: <m3mzxaq8ra.fsf@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Cc: Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jgarzik@pobox.com>

[hwinfo/hwscan reading 256 bytes of pci config space]

It was indeed libsysfs reading the config space accidentally when one 
(well, I) wouldn't expect it to do this.

If you want to try the fixed hwinfo package (hwinfo-8.70), it's here:

ftp://ftp.suse.com/pub/people/snwint/9.1/hwinfo/


Steffen
