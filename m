From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.24-rc3-mm2: Result: hostbyte=0x01
 driverbyte=0x00\nend_request: I/O error
Date: Wed, 28 Nov 2007 22:12:38 +0000
Message-ID: <20071128221238.4a5ee8bb@the-village.bc.nu>
References: <20071128034140.648383f0.akpm@linux-foundation.org>
	<20071128200130.GA13361@martell.zuzino.mipt.ru>
	<20071128134036.417b3def.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60143 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757621AbXK1WQI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Nov 2007 17:16:08 -0500
In-Reply-To: <20071128134036.417b3def.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

> > [  225.378426] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> > [  225.378659] end_request: I/O error, dev sdb, sector 141295703
> > [  225.390133] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> > [  225.391988] end_request: I/O error, dev sdb, sector 141295703
> > [  225.392463] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> > [  225.392625] end_request: I/O error, dev sdb, sector 141295703
> > [  225.392999] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> > [  225.393161] end_request: I/O error, dev sdb, sector 141295703
> > [  225.393571] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> > [  225.393731] end_request: I/O error, dev sdb, sector 141295703
> > [  225.394382] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> > [  225.394544] end_request: I/O error, dev sdb, sector 141295703
> > [  225.395247] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> > [  225.395412] end_request: I/O error, dev sdb, sector 141295703
> 
> I don't know whether this failure was a scsi thing or an ata thing?

The ATA layer would print diagnostics if it failed the command so I'm a
bit baffled by the report. It looks like the SCSI mid layer rejected it
before we even got it ?
