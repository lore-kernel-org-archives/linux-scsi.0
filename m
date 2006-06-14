From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] Optionally disable QAS in MPT Fusion spi driver
Date: Wed, 14 Jun 2006 17:16:23 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70199768@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:13549 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S965017AbWFNXQ1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jun 2006 19:16:27 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Friday, June 02, 2006 3:14 PM, Andrew Patterson wrote: 
> 
> Certain drives report that they support QAS, but it some 
> cases can have
> trouble with it causing bus resets.  This patch optionally 
> disables QAS
> for the MPT Fusion spi driver.  QAS is disabled using the 
> mpt_qas module
> parameter.
> 
> Andrew
> 
> Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
> 

ACK, James pls apply to your scsi-misc tree.   I validated
the patch here in the labs.

Sorry for the delay. I've been mostly out of the office the
past three weeks.

Eric Moore
LSI Logic
