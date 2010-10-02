From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCHv4 0/19]: New SCSI target framework (SCST) with dev
 handlers and 2 target drivers
Date: Sat, 2 Oct 2010 09:40:21 +0200
Message-ID: <AANLkTi=bfGuL-wrdjYotQFH3x5e+-3H7jzmic9YNppbx@mail.gmail.com>
References: <4CA653F0.1010008@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53919 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab0JBHkn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Oct 2010 03:40:43 -0400
Received: by iwn5 with SMTP id 5so4708704iwn.19
        for <linux-scsi@vger.kernel.org>; Sat, 02 Oct 2010 00:40:43 -0700 (PDT)
In-Reply-To: <4CA653F0.1010008@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, Vladislav Bolkhovitin <vst@vlnb.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, James Smart <James.Smart@emulex.com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>

On Fri, Oct 1, 2010 at 11:34 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>
> Hi All,
>
> Please review the next iteration of the patch set of the new (although,
> in fact, the oldest) SCSI target framework for Linux SCST with a set of
> dev handlers and 3 target drivers: for local access (scst_local), for
> Infiniband SRP (srpt) and IBM POWER Virtual SCSI .
>
> [ ... ]

Note: as far as I know currently SCST is the first and only in-kernel
target storage framework that satisfies both criteria (1) and (2) as
defined during the LSF 2010 summit storage track (see also
http://lwn.net/Articles/400589/):

1. Being a drop in replacement for STGT (the current in-kernel target
mode driver).
2. Using a modern sysfs based control and configuration plane.

Regarding criterion (3), that the code was reviewed as clean enough
for inclusion: any feedback is welcome.

Bart.
