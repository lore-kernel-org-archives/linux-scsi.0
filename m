From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg_scan -i /dev/sg[0123] /dev/hd[abcd] /dev/scd[0123]
Date: 10 Dec 2003 11:14:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1071080061.26823.112.camel@patibmrh9>
References: <1070670440.3056.7.camel@patibmrh9>
	 <3FD43229.7070708@torque.net>  <1070906283.2263.101.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:35545 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263784AbTLJSOk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2003 13:14:40 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id A8E1E1C22
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2003 11:14:39 -0700 (MST)
In-Reply-To: <1070906283.2263.101.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> > Maybe sg_scan should renamed sam_scan (sadly apart from INQUIRYs
> > on st and osst devices).
> 
> ... guessing ...
> an "st device" is a PDT x01 device ... CONFIG_CHR_DEV_ST, ...
> osst is something like st but distinct.

Via `grep _ST .config` I now recall that here in linux-scsi once I
guessed st is part/all of what CONFIG_CHR_DEV_ST builds.

Following that pattern by trying `grep _OSST .config`, I now guess
"osst" is part/all of what CONFIG_CHR_DEV_OSST builds.

Pat LaVarre


