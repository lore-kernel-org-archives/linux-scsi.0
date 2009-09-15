From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: SMART causes disks to go offline on an LSI SAS 1068 controller
Date: Tue, 15 Sep 2009 09:25:49 +0200
Message-ID: <20090915072549.GB27050@boogie.lpds.sztaki.hu>
References: <4AAEC504.2030203@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:40317 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758182AbZIOHZq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2009 03:25:46 -0400
Content-Disposition: inline
In-Reply-To: <4AAEC504.2030203@sauce.co.nz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Richard Scobie <richard@sauce.co.nz>

Hi!

(Please Cc: me, I'm not subscribed)

> It is possibly a smartmontools build issue - it does not like -pie or
> -fpie compiler flags.
> 
> See: https://bugzilla.redhat.com/show_bug.cgi?id=452389
>
> and I reported it on the smartmontools list, but there was no resolution
> that I am aware of.

I've seen that report but according to the buildd logs at
https://buildd.debian.org/fetch.cgi?pkg=smartmontools;ver=5.38%2Bsvn2879-4;arch=amd64;stamp=1252352014
Debian does not use -pie or -fpie.

Also, the 2.6.22 kernel did not drop the disks using the same smart
binaries (version 5.38 at that time), so something must have changed on
the kernel side too.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
