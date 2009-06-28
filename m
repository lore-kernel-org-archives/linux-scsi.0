From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] bnx2i remove not so useful global variable
 bnx2i_reg_devices
Date: Sun, 28 Jun 2009 09:33:51 -0500
Message-ID: <1246199631.4190.7.camel@mulgrave.site>
References: <1245805860.9829.50.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40580 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbZF1Odv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Jun 2009 10:33:51 -0400
In-Reply-To: <1245805860.9829.50.camel@anilgv-desktop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Veerabhadrappa <anilgv@broadcom.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, mchan@broadcom.com

On Tue, 2009-06-23 at 18:11 -0700, Anil Veerabhadrappa wrote:
> >From a8267738e9ca5c73ad6c0d89f17cf864bfc908c8 Mon Sep 17 00:00:00 2001
> From: Anil Veerabhadrappa <anilgv@broadcom.com>
> Date: Tue, 23 Jun 2009 13:56:29 -0700
> Subject: [PATCH]     bnx2i - remove global variable bnx2i_reg_devices
> 
>     * Removed bnx2i_reg_devices as this counter is not really
>       used in a meaningful way
>     Cc: Mike Christie <michaelc@cs.wisc.edu>
> 
> Signed-off-by: Michael Chan <mchan@broadcom.com>
> Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>

Tell me what these signoffs mean:  The first signoff by Michael Chan
implies it's his patch, but it has your authorship information.

James


