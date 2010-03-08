From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] Remove slash in QlogicPTI irq name
Date: Mon, 08 Mar 2010 10:53:18 -0800 (PST)
Message-ID: <20100308.105318.68421217.davem@davemloft.net>
References: <alpine.SOC.1.00.1003081809380.26387@math.ut.ee>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60987
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755086Ab0CHSw6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2010 13:52:58 -0500
In-Reply-To: <alpine.SOC.1.00.1003081809380.26387@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mroos@linux.ee
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Mon, 8 Mar 2010 20:23:20 +0200 (EET)

> qlogicpti driver registers its irq with a name containing slash.
> This results in 
> 
> [   71.049735] WARNING: at fs/proc/generic.c:316 __xlate_proc_name+0xa8/0xb8()
> [   71.132815] name 'Qlogic/PTI'
> 
> because proc_mkdir with the name of the irq fails. Fix it by just 
> removing the slash from irq name. Discovered and tested on real hardware 
> (Sun Ultra 1).
> 
> Signed-off-by: Meelis Roos <mroos@linux.ee>

Applied, thanks a lot!
