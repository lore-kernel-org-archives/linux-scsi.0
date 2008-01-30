From: Keith Hopkins <vger@hopnet.net>
Subject: Re: aic94xx: failing on high load (another data point)
Date: Wed, 30 Jan 2008 18:55:33 +0800
Message-ID: <47A057A5.6000009@hopnet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [221.218.196.247] ([221.218.196.247]:41224 "EHLO
	mail.hopnet.net" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755382AbYA3LRR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2008 06:17:17 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.hopnet.net (Postfix) with ESMTP id 8BB953A26
	for <linux-scsi@vger.kernel.org>; Wed, 30 Jan 2008 18:55:34 +0800 (CST)
Received: from mail.hopnet.net ([127.0.0.1])
	by localhost (hades.hopnet.lan [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l1odT9l5SsZy for <linux-scsi@vger.kernel.org>;
	Wed, 30 Jan 2008 18:55:33 +0800 (CST)
Received: from [192.168.101.2] (titan.hopnet.lan [192.168.101.2])
	by mail.hopnet.net (Postfix) with ESMTP id D23A12E91
	for <linux-scsi@vger.kernel.org>; Wed, 30 Jan 2008 18:55:33 +0800 (CST)
References: 20080124144223.GB14728@alaris.suse.cz
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>     We've tried new adaptec firmware shipped with SLES and we got
> ourselves new error string that appears just above error messages that you
> have seen before and that were attached to the original message:

> kernel: aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=0x6
> kernel: aic94xx: escb_tasklet_complete: Can't find task (tc=71) to abort!
> 
> Do you think they have any significance?

Hi Jan,

Which firmware version is that?

I get similar errors under a high load (rebuilding sw raid1 partitions) with sequencer Firmware version 1.1 (V28), which will eventually hang my box.  Prev fw versions would also hang in similar situations.

My box being OpenSuSE 10.3, a 2.6.22.13-0.3-default kernel,
2x quad core Xeon CPU E5345 @ 2.33GHz stepping 0b,
14G of DDR2-667 memory, and a
Adaptec 48300 (AIC-9410W SAS/SATA Host Adapter, device 0000:05:02.0)
directly connected to two SEAGATE ST3146855SS

My 2 bits.

--Keith Hopkins


