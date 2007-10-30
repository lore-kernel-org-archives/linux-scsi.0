From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [linux-scsi-owner@vger.kernel.org: BOUNCElinux-scsi@vger.kernel.org:
Date: Tue, 30 Oct 2007 15:19:39 +0000
Message-ID: <20071030151938.GA6394@infradead.org>
References: <00df01c81ae9$0f49b510$6200a8c0@jameshsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:44117 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbXJ3PTs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 11:19:48 -0400
Content-Disposition: inline
In-Reply-To: <00df01c81ae9$0f49b510$6200a8c0@jameshsu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jameshsu <jameshsu@acard.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>

On Tue, Oct 30, 2007 at 07:36:05PM +0800, jameshsu wrote:
> Hello James Bottomley,
> 
> This driver has nothing changed since last time submit.
> However recently we check the 2.6.23.1 kernel and found code is not
> up-to-date (still remain @2005).
> Resend this message to submit the same driver again. (.c diff file under
> atp870u.c.diff.bz2 format)
> Please help Acard to build in this modified SCSI driver with latest Linux
> kernel.
> If any code still volient the documentation, please let us know the reasons
> and file path.
> Thanks!

I tried applying both patches but none of them applies.  atp870u.h.diff reverse-applies
so we're at the state already after your patch, and atp870u.c.diff doesn't apply at all,
partially because the before version you have has dos line endings, while atp870u.c
in the kernel doesn't.

> 
> James Hsu
> ----- Original Message -----
> From: jameshsu
> To: postmaster@vger.kernel.org
> Cc: 'David Miller' ; James Bottomley
> Sent: Thursday, March 29, 2007 3:36 PM
> Subject: Re: FW: [linux-scsi-owner@vger.kernel.org:
> BOUNCElinux-scsi@vger.kernel.org: - - Completed
> 
> 
> To whom can take care of this driver issues:
> 
> We, Acard, modified this driver again based on James Bottomley's input
> 3/16/2007.
> In the mean time, I attach the source code with another email for James
> Bottomley.
> 
> Those changes are:
> 1.Modify coding style.
>  2.Add old copy right.
>  3.CompString, ClearString, CopyString routine replaced with memcmp, memset
> and memcpy.
>  4.Remove adapters array form 2.6 kernel.
>  5.Removed the scsi_data_direction() hack macro.Just pass the direction
> directly into the functions
>  6.Use defined values instead of bare numbers (REQUEST_SENSE instead of
> 0x03)
>  7.Replace page_address() to get arbitrary userspace memory with
> kmap_atomic()/kunmap_atomic().
>  8.Use SAM_STAT_CHECK_CONDITION/GOOD instead of separate #define
>  9.Removed home defined READ_6, WRITE_6 etc.
> 10.Return SCSI_MLQUEUE_HOST_BUSY on out of resources in queuecommand.
> 
> Please let me know if this submission is proper.
> Again, relly appreciate for your help!
> 
> James Hsu,
> Manager,QA Testing Dept.
> ACARD TECHNOLOGY CORP.
> Taipei Hsien,Taiwan
> 6F No78,Sec 1,Kwang Fu Road,Sang Chung,
> (02)8512-2290 x 2311(O),(02)8512-2548(FAX)
> 0968-989-555 (mobile)



---end quoted text---
