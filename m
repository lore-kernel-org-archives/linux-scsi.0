From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] aic94xx: fix SSP IU status print-out
Date: Tue, 02 Oct 2007 13:11:24 -0400
Message-ID: <47027BBC.5040708@garzik.org>
References: <20070930140317.GA7134@havoc.gtf.org>	 <4702399A.9010708@garzik.org>	 <1191334857.3530.39.camel@localhost.localdomain>	 <47025743.3070100@garzik.org>	 <1191336373.3530.62.camel@localhost.localdomain>	 <47025A4E.6040200@garzik.org> <1191337213.3530.71.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60792 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbXJBRL2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 13:11:28 -0400
In-Reply-To: <1191337213.3530.71.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> So I know, beyond a shadow of a doubt, that there are no non-x86 users
> of this.

If you don't get the DMA direction right on x86, swiotlb will corrupt 
your data.

	Jeff



