From: Andrew Vasquez <praka@pobox.com>
Subject: Re: [2.6 patch] SCSI qla2xxx: fix inline compile errors
Date: Fri, 16 Jul 2004 01:33:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040716083351.GB18172@praka.san.rr.com>
References: <20040715191131.GA25633@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:10397 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266557AbUGPPqT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jul 2004 11:46:19 -0400
Content-Disposition: inline
In-Reply-To: <20040715191131.GA25633@fs.tum.de>
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Thu, 15 Jul 2004, Adrian Bunk wrote:

> Trying to compile the SCSI qla2xxx driver in 2.6.8-rc1-mm1 using gcc 3.4 
> results in the following compile errors:
> 
> <--  snip  -->
> ...
> <--  snip  -->
> 
> 
> The patch below moves some inlined functions above the place where they
> are called the first time.
> 

Thanks -- I'll add the patch to my tree.  James, please apply.

--
Andrew Vasquez
