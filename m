From: Volker Kuhlmann <list0570@paradise.net.nz>
Subject: Re: [PATCH] sg_io_hdr 32 bit binary compatibility on AMD64
Date: Sun, 15 Jan 2006 21:07:28 +1300
Message-ID: <20060115080728.GF12885@paradise.net.nz>
References: <20060113220854.GD12885@paradise.net.nz> <20060115065752.GE12885@paradise.net.nz> <43C9FB81.9010609@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 203-79-122-66.cable.paradise.net.nz ([203.79.122.66]:45367 "EHLO
	kereru.site") by vger.kernel.org with ESMTP id S1751863AbWAOIHc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Jan 2006 03:07:32 -0500
Received: from kereru.site (localhost [127.0.0.1])
	by kereru.site (8.13.4/8.13.4/SuSE Linux 0.7) with ESMTP id k0F87STQ022790
	for <linux-scsi@vger.kernel.org>; Sun, 15 Jan 2006 21:07:30 +1300
Received: (from volker@localhost)
	by kereru.site (8.13.4/8.13.4/Submit) id k0F87S09022789
	for linux-scsi@vger.kernel.org; Sun, 15 Jan 2006 21:07:28 +1300
Content-Disposition: inline
In-Reply-To: <43C9FB81.9010609@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi Doug,

> I haven't looked at the sane scsi code for some time.
> What came to mind was whether it would be easier to convert
> sanei_scsi.c t use the SG_IO ioctl provided by the sg
> driver.

It's not quite the same.
It wouldn't help already existing software. (How much is there?)
sanei_scsi.c might not be the only piece of software which uses
write()/read() calls. This is also about the general ability of Linux to
run 32bit apps on 64bit hardware.
How different is the ioctl(SG_IO)? I thought it was blocking, which
might be the reason the read/write method exists as well? Are there apps
which rely on non-blocking I/O?

Volker

-- 
Volker Kuhlmann			is possibly list0570 with the domain in header
http://volker.dnsalias.net/		Please do not CC list postings to me.
