From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: + scsi-blacklist-the-easyraid-f8-ide2scsi-adaptor.patch added
	to -mm tree
Date: Sat, 28 Jul 2007 09:56:15 -0400
Message-ID: <1185630975.11492.12.camel@localhost.localdomain>
References: <200707272030.l6RKU2Vw008612@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35939 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751529AbXG1N4U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Jul 2007 09:56:20 -0400
In-Reply-To: <200707272030.l6RKU2Vw008612@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, andmike@us.ibm.com, mog.johnny@gmx.net, protasnb@gmail.com, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2007-07-27 at 13:30 -0700, akpm@linux-foundation.org wrote:
> The patch titled
>      scsi: blacklist the easyRAID F8 IDE2SCSI adaptor
> has been added to the -mm tree.  Its filename is
>      scsi-blacklist-the-easyraid-f8-ide2scsi-adaptor.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: scsi: blacklist the easyRAID F8 IDE2SCSI adaptor
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> According to http://bugzilla.kernel.org/show_bug.cgi?id=5953, this patch fixes
> easyRAID domain validation.

I don't think this can be true ... the patch definitely fixes the
condition on the easyraid where it goes haywire and responds with
complete rubbish to the REPORT LUNS command (which is all too common for
these IDE raid things), but DV will occur long before the REPORT LUNS is
tried.

I'll take it through the SCSI tree because it's clearly a bug, but it's
probably only half the fix.

James


