From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] MPT FUSION driver causes panic on bootup on PPC 970 k
	ernel
Date: Mon, 25 Jul 2005 15:59:28 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C0343C6D7@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:28843 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261180AbVGYV7o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 17:59:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Bellon <mbellon@mvista.com>
Cc: linux-scsi@vger.kernel.org

These endian fix's have already been submitted long ago.
Try a newer kernel, such as 2.6.13-rc3.

Thankyou,

Eric Moore
LSI Logic

On Monday, July 25, 2005 3:48 PM, Mark Bellon wrote:
> 
> 
> A PPC 970 kernel with the MPT FUSION driver configured in would cause 
> the kernel to panic. The problem occurs because of some apparently 
> incorrect logic dealing with the cpu_to_le* and le*_to_cpu routines.
> 
> Patch is attached. Comments?
> 
> mark
> 
> 
> 
> 
