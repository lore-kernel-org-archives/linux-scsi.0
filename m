From: "Brown, Len" <len.brown@intel.com>
Subject: RE: 2.6.13-mm1: hangs during boot ...
Date: Sat, 3 Sep 2005 00:22:47 -0400
Message-ID: <F7DC2337C7631D4386A2DF6E8FB22B30047FA061@hdsmsx401.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr16.intel.com ([192.55.52.70]:4017 "EHLO
	fmsfmr006.fm.intel.com") by vger.kernel.org with ESMTP
	id S1161120AbVICEXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Sep 2005 00:23:00 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Peter Williams <pwil3058@bigpond.net.au>
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

> > [  279.662960]  [<c02d5c74>] wait_for_completion+0xa4/0x110

possibly a missing interrupt?

> CONFIG_ACPI=y

any difference if booted with "acpi=off" or "acpi=noirq"?
