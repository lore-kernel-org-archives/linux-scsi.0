From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 0/6] mpt fusion - fibre channel updates / bug fixes
Date: Fri, 19 May 2006 17:41:04 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7011BA54@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39082 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932161AbWESXlH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 May 2006 19:41:07 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thursday, May 18, 2006 1:59 PM, Michael Reed wrote:  

> If possible, 2.6.17.
> 
> Bugs fixed:
> 
> 	* fibre channel target discovery prematurely terminates
> 	* fix infinite request/response loop during board reset
> 	* interrupting board reset with ctrl-c can leave board
> 	  unusable, requiring reboot to recover
> 
> Code reorg:
> 
> 	* move fibre channel event and reset handling to mptfc
> 	  (better isolates future changes to this module)
> 
> Bug fix / feature: (depends upon point of view)
> 
> 	* Set firmware target missing timers to one second so that
> 	  the transport's dev loss timer is more quickly started
> 


These set of patchs were submitted to LSI a couple weeks ago;
they have been through source review, and test at both LSI and 
SGI sites. Pls apply.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>
