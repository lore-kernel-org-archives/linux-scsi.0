From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [UPDATED PATCH] SGIWD93: use cached memory access to make
	driver work on IP28
Date: Sat, 8 Dec 2007 16:04:49 +0000
Message-ID: <20071208160449.GA3361@linux-mips.org>
References: <20071202103309.6A926C2EB4@solo.franken.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ftp.linux-mips.org ([194.74.144.162]:40948 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbXLHSb2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Dec 2007 13:31:28 -0500
Received: from localhost.localdomain ([127.0.0.1]:47253 "EHLO
	dl5rb.ham-radio-op.net") by ftp.linux-mips.org with ESMTP
	id S20026996AbXLHSb0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Dec 2007 18:31:26 +0000
Content-Disposition: inline
In-Reply-To: <20071202103309.6A926C2EB4@solo.franken.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-scsi@vger.kernel.org, linux-mips@linux-mips.org, James.Bottomley@HansenPartnership.com

On Sun, Dec 02, 2007 at 11:33:09AM +0100, Thomas Bogendoerfer wrote:

> SGI IP28 machines would need special treatment (enable adding addtional
> wait states) when accessing memory uncached. To avoid this pain I
> changed the driver to use only cached access to memory.
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Acked-by: Ralf Baechle <ralf@linux-mips.org>

The machine really is as insane as Thomas makes it sound.  Actually even
more so.

  Ralf
