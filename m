From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: Re:Adaptec SCSI adapter hanging
Date: Tue, 10 Feb 2004 14:52:21 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4028E215.2060107@wanadoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp15.eresmas.com ([62.81.235.115]:64182 "EHLO
	smtp15.in.mad.eresmas.com") by vger.kernel.org with ESMTP
	id S265877AbUBJN65 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 08:58:57 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, mulac@civ.zcu.cz

Milos Mulac wrote:

> I have dual opteron server (Processor 244, board K8T Master, Adaptec
> 29320LP Ultra320 SCSI adapter).
> 
> There is SuSE ES8 installed with 2.4.25-rc1 kernel (however I have tested
> 2.4.24, 2.4.21 with the same result). When I try to use disk more
> intensively (cp /dev/sda /dev/null), the load suddenly rises to the sky
> and if you do not break the 'cp' within several seconds, server hangs.

SuSE Enterprise Server, like Red Hat Enterprise, is *not* built to run
kernel.org's kernels. Try it with _its latest errata kernel_

--
LiNUX Is Not UniX



