From: Andrew Morton <akpm@osdl.org>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Thu, 16 Sep 2004 13:11:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040916131142.280cbf06.akpm@osdl.org>
References: <B179AE41C1147041AA1121F44614F0B060EF48@AVEXCH02.qlogic.org>
	<20040916121235.5e4f9c32.pj@sgi.com>
	<1095362263.16326.12.camel@praka>
	<20040916125631.1f25dfdb.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:11412 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S268183AbUIPUOF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2004 16:14:05 -0400
In-Reply-To: <20040916125631.1f25dfdb.pj@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Paul Jackson <pj@sgi.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com

Paul Jackson <pj@sgi.com> wrote:
>
>  I am still seeing the SN2 SCSI QLA failure as I reported yesterday, but
>  now against 2.6.9-rc2-mm1.

Is it an acpi thing?  Try reverting the three
incorrect-pci-interrupt-assignment* patches?
