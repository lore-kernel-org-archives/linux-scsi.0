From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: [PATCH 1/1] scsi : megaraid_{mm,mbox}: a fix on 64-bit DMAcapability check
Date: Tue, 30 May 2006 06:57:43 -0600
Message-ID: <890BF3111FB9484E9526987D912B261901BD98@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:19877 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751063AbWE3M60 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 08:58:26 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Vasily Averin <vvs@sw.ru>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,
 
> Well, this really isn't quite right.  There are 32 bit platforms which
> will refuse a 64 bit DMA mask on principle.  You need to 
> retry with a 32
> bit mask before erroring out, exactly like you've done in 
> megaraid_sas.c
> 
> Also, it's a bit strange having a 32 bit mask set initially 
> in probe_one
> and then being reset in init_mbox.  Why not just consolidate 
> all the PCI
> register testing and mask setting in probe_one?
Thank you for the points!
A patch containing these changes will followed, soon.

Seokmann
