From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: Re: problem with megaraid2 driver
Date: Sat, 29 Nov 2003 16:38:57 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FC8BD91.6060201@wanadoo.es>
References: <3FC7696C.2030004@wanadoo.es> <20031128155020.GB18860@odin.sis.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp13.eresmas.com ([62.81.235.113]:50381 "EHLO
	smtp13.eresmas.com") by vger.kernel.org with ESMTP id S263777AbTK2Pji
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2003 10:39:38 -0500
List-Id: linux-scsi@vger.kernel.org
To: Gabor Burjan <buga@buvoshetes.hu>, linux-scsi <linux-scsi@vger.kernel.org>

Gabor Burjan wrote:

> Is that possible that only the new driver triggers the problem which is
> "built-in" in the firmware, while using the old driver everything seems
> to be OK?

1.18k and 2.00.9 are very different drivers.

It looks like the firmware of the board is unable to
complete some commands of the pending list.

megaraid: aborting-4027815 cmd=2a <c=0 t=0 l=0>
megarid: Waiting for 11 commands to flush: iter:0
megarid: Waiting for 11 commands to flush: iter:1000
megarid: Waiting for 11 commands to flush: iter:2000
megaraid: aborted cmd 3d75a7[76] complete.
megarid: Waiting for 8 commands to flush: iter:3000
[... 4000, 5000, 6000, ... 59000]
megarid: Waiting for 8 commands to flush: iter:60000
megaraid: critical hardware error!

If those command were completed you would see the message:
"megaraid: abort sequence successfully complete".

So, try latest firmware.

-- 
There are 10 kinds of people.
Those that know to count in binary and those that no.

