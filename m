From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug 12222] New: kernel BUG at drivers/pci/intel-iommu.c:1373!
Date: Mon, 15 Dec 2008 03:21:07 +0900
Message-ID: <20081215032141K.fujita.tomonori@lab.ntt.co.jp>
References: <bug-12222-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:45727 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663AbYLNSVn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Dec 2008 13:21:43 -0500
In-Reply-To: <bug-12222-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dwmw2@infradead.org

On Sun, 14 Dec 2008 09:35:38 -0800 (PST)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=12222
> 
>            Summary: kernel BUG at drivers/pci/intel-iommu.c:1373!
>            Product: IO/Storage
>            Version: 2.5
>      KernelVersion: 2.6.26-gentoo-r4
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: john.blbec@centrum.cz
>                 CC: anil.s.keshavamurthy@intel.com
> 
> 
> Latest working kernel version: unknown

Probably, this is a VT-d bug. I saw the same bug report before:

http://lkml.org/lkml/2008/9/8/138

it's worth trying the latest kernel but I guess that the problem still
exists.

As Mark suggested, it's also worth trying 'intel_iommu=strict' kernel
boot option, I think. If it doesn't work, you can use a workaround to
disable VT-d with 'intel_iommu=off' kernel boot option.
