From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: ultrastor.c is a bit-rot
Date: Fri, 21 Mar 2008 13:41:33 -0700
Message-ID: <47E41D7D.9050409@zytor.com>
References: <47DE8736.8020405@panasas.com> <20080317152344.GE26285@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:42417 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762105AbYCUUlv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Mar 2008 16:41:51 -0400
In-Reply-To: <20080317152344.GE26285@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>

Matthew Wilcox wrote:
> 
> VESA Local Bus.  It was (in some sense) the predecessor of AGP.  We
> treat it like ISA inside the kernel.  On x86, EISA depends on ISA, so
> the dependency, while wrong, does not affect any x86 users who have an
> EISA card.
> 

Well, one can say VLB was to ISA (a souped-up ISA bus with some of the 
worst limitations removed) what AGP is to PCI...

	-hpa
