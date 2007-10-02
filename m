From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: fix SSP IU status print-out
Date: Tue, 02 Oct 2007 12:26:27 -0500
Message-ID: <1191345987.3530.104.camel@localhost.localdomain>
References: <20070930140317.GA7134@havoc.gtf.org>
	 <4702399A.9010708@garzik.org>
	 <1191334857.3530.39.camel@localhost.localdomain>
	 <47025743.3070100@garzik.org>
	 <1191336373.3530.62.camel@localhost.localdomain>
	 <47025A4E.6040200@garzik.org>
	 <1191337213.3530.71.camel@localhost.localdomain>
	 <47027BBC.5040708@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60567 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753029AbXJBR0c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 13:26:32 -0400
In-Reply-To: <47027BBC.5040708@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2007-10-02 at 13:11 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > So I know, beyond a shadow of a doubt, that there are no non-x86 users
> > of this.
> 
> If you don't get the DMA direction right on x86, swiotlb will corrupt 
> your data.

Er, this is a fully 64 bit device: it shouldn't use swiotlb.

James


