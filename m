From: Richard Lary <rlary@austin.ibm.com>
Subject: Re: [PATCH] lpfc: add cfg_use_msi test before pci_msi_disable() calls
Date: Fri, 23 Mar 2007 13:27:30 -0500 (CDT)
Message-ID: <200703231827.l2NIRUrp022614@anacortes.austin.ibm.com>
References: <460406BE.30806@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42750 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbXCWSaG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Mar 2007 14:30:06 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2NIU4DH030098
	for <linux-scsi@vger.kernel.org>; Fri, 23 Mar 2007 14:30:04 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2NIU4Ju275100
	for <linux-scsi@vger.kernel.org>; Fri, 23 Mar 2007 14:30:04 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2NIU414015584
	for <linux-scsi@vger.kernel.org>; Fri, 23 Mar 2007 14:30:04 -0400
In-Reply-To: <460406BE.30806@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

> 
> When we put this in, the kernel code that we inspected allowed for
> the call if msi was not enabled (check on dev->msi_enabled), and did
> nothing. Thus, we believed it was in the scope of the interface.
> kfree does the same kind of thing. Testing on 2.6.21-rc4 on a machine
> w/o MSI also results in no issues/messages.

I did some additional research and discovered that the error message
I reported seeing was due to debug code installed on the PPC system
I was performing testing on.

I agree that patch is not required.

-rich
