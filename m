From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH]: Fix old SCSI adapter crashes with CD-ROM (take 2)
Date: Tue, 8 May 2007 18:42:56 +0100
Message-ID: <20070508184256.029cf8a4@the-village.bc.nu>
References: <20070508171710.1ac730cd@the-village.bc.nu>
	<20070508161444.GA4163@kernel.dk>
	<1178642376.3737.36.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [81.2.110.250] ([81.2.110.250]:36911 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965655AbXEHRja (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 May 2007 13:39:30 -0400
In-Reply-To: <1178642376.3737.36.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org

> Mike Christie tells me we're missing bouncing by accident in the
> scsi_execute path (but not the scsi_execute_async path).  He says this
> is the fix he proposed:
> 
> http://marc.info/?l=linux-scsi&m=115981479822790&w=2
> 
> Can we just merge this instead?

Short answer: No

Long answer - it doesn't take this path.

Different bug, both want fixing I suspect.
