From: "Brown, Len" <len.brown@intel.com>
Subject: RE: git-acpi breakage, sym2
Date: Fri, 12 May 2006 03:26:07 -0400
Message-ID: <CFF307C98FEABE47A452B27C06B85BB66D5565@hdsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:39431 "EHLO
	azsmga101-1.ch.intel.com") by vger.kernel.org with ESMTP
	id S1750764AbWELH0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 May 2006 03:26:13 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Wilcox <willy@debian.org>

>The latest
>git+ssh://master.kernel.org/pub/scm/linux/kernel/git/lenb/linux
>-acpi-2.6.git#test
>kills my very vanilla P4 box.

hmmm, killed my p4 box too in a similar way.

booting with "acpi=off" made it work,
so I expect the failures after ACPI refuses to start
are due to ACPI and not do to something outside ACPI.

-Len
