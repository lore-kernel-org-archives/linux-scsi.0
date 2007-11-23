From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: 2.6.24-rc3-mm1
Date: Fri, 23 Nov 2007 02:39:08 +0100
Message-ID: <47462F3C.3040700@googlemail.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:41660 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbXKWBjO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Nov 2007 20:39:14 -0500
Received: by nf-out-0910.google.com with SMTP id g13so2615579nfb
        for <linux-scsi@vger.kernel.org>; Thu, 22 Nov 2007 17:39:12 -0800 (PST)
In-Reply-To: <20071120204525.ff27ac98.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

I have some warnings on each SCSI disc:


...

[   30.724410] scsi 0:0:0:0: Direct-Access     SEAGATE  ST318406LW       0109 PQ: 0 ANSI: 3
[   30.724419] scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
[   30.724435]  target0:0:0: Beginning Domain Validation
[   30.724446]  target0:0:0: Domain Validation Initial Inquiry Failed <--
[   30.724572]  target0:0:0: Ending Domain Validation
[   30.729747] scsi 0:0:1:0: Direct-Access     FUJITSU  MAH3182MP        0114 PQ: 0 ANSI: 4
[   30.729754] scsi0:A:1:0: Tagged Queuing enabled.  Depth 32
[   30.729771]  target0:0:1: Beginning Domain Validation
[   30.729780]  target0:0:1: Domain Validation Initial Inquiry Failed <--
[   30.729908]  target0:0:1: Ending Domain Validation

...

no idea whatever this is related but buffered disk reads are 2.XX MB/sec and the box is somewhat laggy.

hdparm -t on sda and sdb reports :

/dev/sda:
 Timing buffered disk reads:    8 MB in  3.26 seconds =   2.46 MB/sec

/dev/sdb:
 Timing buffered disk reads:    8 MB in  3.56 seconds =   2.25 MB/sec

My IDE discs are fine.

Please let me know if you need my config or any other informations.


Gabriel
