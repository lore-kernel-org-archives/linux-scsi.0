From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: udf folders pointing to self and above
Date: 06 Oct 2003 22:08:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065499688.6066.20.camel@patehci2>
References: <1064864262.4262.49.camel@patehci2>
	 <1064870151.5458.20.camel@patehci2>
	 <20030929143457.3def59f4.rddunlap@osdl.org>
	 <1064872992.5458.50.camel@patehci2>  <1064875668.3175.9.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:34030 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261776AbTJGEIP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2003 00:08:15 -0400
In-Reply-To: <1064875668.3175.9.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: rddunlap@osdl.org
Cc: linux-scsi@vger.kernel.org

> the idea that we maintain udf.ko outside of linux-fsdevel

Also I see the binary points us away from linux-fsdevel:

$
$ dd if=/dev/zero of=dd.bin bs=1M seek=0 count=1
1+0 records in
1+0 records out
$ sudo losetup /dev/loop0 dd.bin
$ sudo mkudffs /dev/loop0 | tail -1
start=511, blocks=1, type=ANCHOR
$ sync
$ sudo losetup -d /dev/loop0
$ strings dd.bin | grep @ | uniq
<linux_udf@hpesjro.fc.hp.com>
$

I haven't yet found a google archive of linux_udf@hpesjro.fc.hp.com.

Pat LaVarre


