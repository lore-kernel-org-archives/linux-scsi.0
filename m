From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] CDC_WR_OVER
Date: 21 Nov 2003 14:18:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069449533.15688.15.camel@patrh9>
References: <1068851585.2851.17.camel@patrh9>
	 <1069200002.2912.8.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:51709 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263158AbTKUVTY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 16:19:24 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 769B22594
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2003 14:19:23 -0700 (MST)
In-Reply-To: <1069200002.2912.8.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Kindly offline I'm told ...

> As yet revising, Not accepting.

Slowly the necessary pieces come into focus:

1) Find the writable-or-not code of sr_mod.ko.
2) Find the writable-or-not code of ide-cd.ko.
3) Move (1) and (2) into cdrom.ko.

4) Teach cdrom.ko to fetch op x46 GPCMD_GET_CONFIGURATION header.
5) Teach cdrom.ko to fetch all reportedly available op x46 data.

6) Learn that more than DVD-RAM is writable.

> > 1) Find the writable-or-not code of sr_mod.ko.
> > 3) Move (1) and (2) into cdrom.ko.
> > 4) Teach cdrom.ko to fetch op x46 GPCMD_GET_CONFIGURATION header.
> > 5) Teach cdrom.ko to fetch all reportedly available op x46 data.

All ok now.

> > 2) Find the writable-or-not code of ide-cd.ko.

Not yet complete.

> > 6) Learn that more than DVD-RAM is writable.

Still feels kluged.

CD-RW and DVD+RW support random rewrites if load balanced.  Those
designs have not pioneered a standard way of saying truly random
rewrites supported, other than saying DVD-RAM.

Pat LaVarre


