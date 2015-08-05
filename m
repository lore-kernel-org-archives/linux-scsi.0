From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/4] cxlflash: Updates to legacy I/O
Date: Wed, 5 Aug 2015 16:39:08 -0500
Message-ID: <8753D713-3227-4EAC-85BA-879CB9E1BB02@linux.vnet.ibm.com>
References: <1438576364-32896-1-git-send-email-mrochs@linux.vnet.ibm.com> <55C22F4C.1030001@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:57063 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbbHEVjQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2015 17:39:16 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 5 Aug 2015 17:39:15 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id C123A38C8039
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2015 17:39:11 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t75LdBtD62849260
	for <linux-scsi@vger.kernel.org>; Wed, 5 Aug 2015 21:39:11 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t75Ld91P022623
	for <linux-scsi@vger.kernel.org>; Wed, 5 Aug 2015 17:39:11 -0400
In-Reply-To: <55C22F4C.1030001@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, wenxiong@linux.vnet.ibm.com, shane.seymour@hp.com, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Aug 5, 2015, at 10:44 AM, Brian King <brking@linux.vnet.ibm.com> wrote:
> 
> Hi Matt,
> 
> Can you break this up into separate patches for these separate logical bug fixes / changes?
> There is too much bundled all into a single patch here from my perspective.

Sure, I can do that for v4.

> 
> Thanks,
> 
> Brian
> 
> -- 
> Brian King
> Power Linux I/O
> IBM Linux Technology Center
> 
> 

