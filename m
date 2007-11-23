From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc3-mm1
Date: Thu, 22 Nov 2007 20:12:50 -0800
Message-ID: <20071122201250.f957e280.akpm@linux-foundation.org>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<47462F3C.3040700@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39785 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753032AbXKWENH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Nov 2007 23:13:07 -0500
In-Reply-To: <47462F3C.3040700@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 23 Nov 2007 02:39:08 +0100 Gabriel C <nix.or.die@googlemail.com> wrote:

> I have some warnings on each SCSI disc:
> 
> 
> ...
> 
> [   30.724410] scsi 0:0:0:0: Direct-Access     SEAGATE  ST318406LW       0109 PQ: 0 ANSI: 3
> [   30.724419] scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
> [   30.724435]  target0:0:0: Beginning Domain Validation
> [   30.724446]  target0:0:0: Domain Validation Initial Inquiry Failed <--
> [   30.724572]  target0:0:0: Ending Domain Validation
> [   30.729747] scsi 0:0:1:0: Direct-Access     FUJITSU  MAH3182MP        0114 PQ: 0 ANSI: 4
> [   30.729754] scsi0:A:1:0: Tagged Queuing enabled.  Depth 32
> [   30.729771]  target0:0:1: Beginning Domain Validation
> [   30.729780]  target0:0:1: Domain Validation Initial Inquiry Failed <--
> [   30.729908]  target0:0:1: Ending Domain Validation
> 

Don't know what would have caused that.  But yes, something is wrong in
scsi land.

> 
> no idea whatever this is related but buffered disk reads are 2.XX MB/sec and the box is somewhat laggy.
> 
> hdparm -t on sda and sdb reports :
> 
> /dev/sda:
>  Timing buffered disk reads:    8 MB in  3.26 seconds =   2.46 MB/sec
> 
> /dev/sdb:
>  Timing buffered disk reads:    8 MB in  3.56 seconds =   2.25 MB/sec
> 
> My IDE discs are fine.
> 
> Please let me know if you need my config or any other informations.
> 

And you're the second to report very slow scsi throughput in 2.6.24-rc3-mm1.
