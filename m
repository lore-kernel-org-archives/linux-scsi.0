From: Douglas Gilbert <dougg@torque.net>
Subject: Re: scsi_debug fault-injection question
Date: Mon, 11 Jun 2007 14:26:55 -0400
Message-ID: <466D93EF.8060609@torque.net>
References: <20070611094207.168a7664.randy.dunlap@oracle.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38482 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbXFKS1f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jun 2007 14:27:35 -0400
In-Reply-To: <20070611094207.168a7664.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, dgilbert@interlog.com

Randy Dunlap wrote:
> Hi Doug,
> 
> scsi_debug.c says:
> 
> MODULE_PARM_DESC(every_nth, "timeout every nth command(def=100)");
> 
> I don't see where the default of 100 is set.
> 
> #define DEF_EVERY_NTH   0
> ...
> static int scsi_debug_every_nth = DEF_EVERY_NTH;
> 
> 
> Can you clarify for me, please?

Randy,
s/100/0/

The string in MODULE_PARM_DESC is wrong. The support
web page, http://www.torque.net/sg/sdebug26.html
is accurate stating the default is 0 and notes:
"for error injection: 0 -> off".

Doug Gilbert

