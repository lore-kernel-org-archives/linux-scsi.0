From: Gabor Burjan <buga@buvoshetes.hu>
Subject: Re: problem with megaraid2 driver
Date: Thu, 4 Dec 2003 10:56:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031204095654.GA9107@odin.sis.hu>
References: <3FC7696C.2030004@wanadoo.es> <20031128155020.GB18860@odin.sis.hu> <3FC8BD91.6060201@wanadoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from odin.sis.hu ([212.92.23.29]:45188 "EHLO odin.sis.hu")
	by vger.kernel.org with ESMTP id S263274AbTLDJ44 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2003 04:56:56 -0500
Content-Disposition: inline
In-Reply-To: <3FC8BD91.6060201@wanadoo.es>
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose@wanadoo.es>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sat, Nov 29, 2003 at 04:38:57PM +0100, Xose Vazquez Perez wrote:

> It looks like the firmware of the board is unable to
> complete some commands of the pending list. [...]
> 
> So, try latest firmware.

Thank you, that solved the problem.

for the archive, this combination is running now:

adapter: LSI MegaRAID SCSI 320-1
megaraid2 driver v2.00.9
firmware 1L26:G112.

Gabor
