From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: usb storage traces
Date: 11 Nov 2003 14:59:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068587962.5909.6.camel@patrh9>
References: <1068501874.6380.19.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:56000 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263795AbTKKV7y
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2003 16:59:54 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 7599628E4
	for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2003 14:59:53 -0700 (MST)
In-Reply-To: <1068501874.6380.19.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> ... traces of Win XP/2K with DVD/CD
> as life begins after plug in ...

Saw one, thanks.

Wow.  Lookathat.  At least once on Earth, we saw Microsoft Windows Do
The Right Thing according to T10.  Wow.  Maybe Microsoft wrote the pdt
x05 DVD/CD code after being informed by their history of pain with pdt
x00 HDD/flash?

I actually saw Win XP SP1 begin life after plug in with three
politically correct speeches:

1) GPCMD_INQUIRY for standard length:

gccscsi -i x24 -y "12 00:00:00 24 00"

2) GPCMD_GET_CONFIGURATION for header alone:

gccscsi -i 8 -y "46 00 00:00:00:00 00 00:08 00"

3) GPCMD_GET_CONFIGURATION for offset + field length + value of
additionalLength field, which for this sample drive was:

gccscsi -i xF8 -y "46 00 00:00:00:00 00 00:F8 00"

Wow.  Lookathat.

Pat LaVarre


