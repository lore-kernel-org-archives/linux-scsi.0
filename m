From: Olaf Hering <olh@suse.de>
Subject: Re: oops in ibmvstgt, in __scsi_alloc_queue
Date: Sun, 2 Mar 2008 13:57:39 +0100
Message-ID: <20080302125739.GA2623@suse.de>
References: <20080229155825.GA25293@suse.de> <20080301154342O.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:41946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbYCBM5p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Mar 2008 07:57:45 -0500
Content-Disposition: inline
In-Reply-To: <20080301154342O.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Sat, Mar 01, FUJITA Tomonori wrote:

> On Fri, 29 Feb 2008 16:58:25 +0100
> Olaf Hering <olh@suse.de> wrote:
> > NIP [d00000000009ed80] .__scsi_alloc_queue+0xa4/0x130 [scsi_mod]
> > LR [d00000000009ed7c] .__scsi_alloc_queue+0xa0/0x130 [scsi_mod]
> 
> Thanks for report.
> 
> Can you try the following patchset?
> 
> http://marc.info/?l=linux-scsi&m=120435349330391&w=2

The 4 patches fix the oops.
Thanks.
