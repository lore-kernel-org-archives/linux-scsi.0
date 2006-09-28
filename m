From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] fusion: fibre channel: stall eh handlers if resetting while rport blocked
Date: Thu, 28 Sep 2006 12:26:57 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D703500B9@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:38091 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030350AbWI1S1B convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Sep 2006 14:27:01 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>

On  Wednesday, September 27, 2006 10:10 AM, Michael Reed wrote:
> This patch applies against 2.6.18-git7.
> Thanks to James Smart for the inspiration.
> 
> Stall error handler if attempting recovery while an rport is blocked.
> This avoids device offline scenarios due to errors in the 
> error handler.
> Also verify that VirtDevice is available before issuing scsi command.
> VirtDevice is removed when fc transport removes a target.
> 
> See James Smart's patch of 08/17/2006 for greater detail.
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=115583213624803&w=2
> 
> Also bump version number per Eric's request.
> 

ACK
