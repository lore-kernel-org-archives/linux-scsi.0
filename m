From: David Haring <david.haring@billboard.cz>
Subject: Re: [2.4.25], [aic79xx-2.0.8] problems with aic79xx on 2.4 (fwd)
Date: Tue, 06 Apr 2004 23:24:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40732013.2080904@billboard.cz>
References: <20040406212126.A30706@www.goron.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.billboard.cz ([194.213.62.38]:24329 "EHLO ns.billboard.cz")
	by vger.kernel.org with ESMTP id S264025AbUDFVY7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2004 17:24:59 -0400
In-Reply-To: <20040406212126.A30706@www.goron.de>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ari <ari@goron.de>, abba@cs.sunysb.edu

Hello,

I would recommend reducing TCQ depth too - I have also had
troubles with recent Maxtor Atlas disks / Adaptec / aic79xx
and reducing TCQ depth solved the problem.

Interesting note though - the troubles only showed with Adaptec
controller. When I have replaced the Adaptec aic79xx SCSI card
with Tekram Ultra320 one the system worked without problem.

Ari wrote:
> 
> Hi,
> I've ran into similar problems with the same controller and same disks
> (Maxtor Atlas 10K4 73G WLS, mine are revision DFV0 however).
> After a lot of frustration including changing all related hardware,
> especially the cabling, resultless googling, etc, I found the solution:
> Speeding down the disks does not really help. It works better, but under
> stress load (3 bonnie++ at the same time) they quickly produce lost
> SCB commands, even at 80Mhz.
> What fixed it for me was limiting the Tagged Queuing depth to 16 (in
> kernel config). After my raid5 array worked flawlessly under a 24h
> 3 simultaneous bonnie++ test.
> I've found some hints googling that there might be a firmware problem
> related to this (which should be fixed with the DFV0 version on my
> drives, but obviously is not).
> Anyhow, try to reduce tagged queuing to 16, if that fixes it, it will
> also confirm my findings.

David Haring


