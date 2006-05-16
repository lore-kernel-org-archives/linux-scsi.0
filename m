From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: Help: strange messages from kernel on IA64 platform
Date: Tue, 16 May 2006 14:50:19 -0600
Message-ID: <890BF3111FB9484E9526987D912B261901BD84@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:30950 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750780AbWEPUuV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 16:50:21 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org

Hi,

During communication in between application and megaraid driver via
IOCTL, the system displays messages which are not easy to track down.
Following is one of the messages and same messages with different values
are poping up regularly.
---
Kernel unaligned access to 0xe00000007f3d80dc ip=0xa0000002000373b1
---

I understand the kernel is complaining about the address which is not
aligned and, found the message is coming from function
'ia64_handle_unaligned()' in the arch/ia64/kernel/unaligned.c.
But, I couldn't find who is calling this function and further details of
reasons.

Where should I start to figure out it?

Thank you,

Seokmann
