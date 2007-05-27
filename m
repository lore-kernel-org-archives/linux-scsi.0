From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 5/5] SCSI/initio conversion to PCI driver API
Date: Sun, 27 May 2007 11:03:53 -0400
Message-ID: <46599DD9.4020408@garzik.org>
References: <20070527145200.GA17017@havoc.gtf.org> <20070527145955.GE17085@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40020 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbXE0PDz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 May 2007 11:03:55 -0400
In-Reply-To: <20070527145955.GE17085@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>

Jeff Garzik wrote:
> Prior simplifications in this patchset now permit a minimal conversion
> to the new PCI API.
> 
> Further improvements and simplifications are certainly possible; those
> should be presented in a separate patchset.
> 
> DO NOT APPLY (yet).  For feedback (and testers?) only.


This only applies to patch #5.

Patches 1 through 4 should go upstream, IMO.

	Jeff


