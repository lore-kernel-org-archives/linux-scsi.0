From: Andrew Vasquez <praka@san.rr.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b2).
Date: Thu, 29 May 2003 08:17:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030529151726.GA29206@praka.local.home>
References: <20030519225728.GA17279@praka.local.home> <20030521173215.GA25137@praka.local.home> <20030521222635.GB21124@krispykreme> <20030529061913.GA27199@praka.local.home> <3ED61888.6040407@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orngca-mls02.socal.rr.com ([66.75.160.17]:59274 "EHLO
	orngca-mls02.socal.rr.com") by vger.kernel.org with ESMTP
	id S262289AbTE2PK4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 May 2003 11:10:56 -0400
Received: from san.rr.com (66-75-128-22.san.rr.com [66.75.128.22])
	by orngca-mls02.socal.rr.com (8.11.4/8.11.3) with ESMTP id h4TFKwL12178
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2003 08:20:58 -0700 (PDT)
Received: from san.rr.com (localhost [127.0.0.1])
	by san.rr.com (8.12.3/8.12.3/SuSE Linux 0.6) with ESMTP id h4TFHQjW029232
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2003 08:17:26 -0700
Received: (from praka@localhost)
	by san.rr.com (8.12.3/8.12.3/Submit) id h4TFHQCd029231
	for linux-scsi@vger.kernel.org; Thu, 29 May 2003 08:17:26 -0700
Content-Disposition: inline
In-Reply-To: <3ED61888.6040407@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thu, 29 May 2003, Jeff Garzik wrote:

> >  it seems several drivers
> >(i.e. sym53c8xx_2, aic7xxx) ensure the memory-mapped resource begins
> >on a page boundary before passing it onto ioremap().  Yet, in the code
> >for __ioremap(), (arch/i386/mm/ioremap.c) there is this small comment:
> >
> >	/*
> >	 * NOTE! We need to allow non-page-aligned mappings too: we
> >	 * will obviously have to convert them into an offset in a
> >	 * page-aligned mapping, but the caller shouldn't need to know
> >	 * that small detail.
> >	 *
> >	 */
> >
> >Is it safe to assume *all* platforms will handle this case internally,
> >or should drivers perform the pre-process?
> 
> They better.  It is expected that you can pass the bus address returned 
> from pci_resource_start directly to ioremap (after ensuring availability 
> by calling pci_request_regions).
> 

Thanks for the clarification.

--
Andrew Vasquez
