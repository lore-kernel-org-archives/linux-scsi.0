From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 1/10] mptfusion : Transport Layer Retry support
Date: Thu, 13 Jul 2006 14:45:27 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D701F693B@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:51884 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030377AbWGMUpl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jul 2006 16:45:41 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

-- Wednesday, July 12, 2006 1:26 PM, James Bottomley: 


> On Wed, 2006-07-12 at 13:18 -0600, Moore, Eric wrote:
> > If the mode pages method worked properly, they wouldn't had 
> to go this
> > other route.  
> 
> Well .. yes ... however, it does look like they should be 
> able to get at
> this via the mode pages of the Report Luns W-LUN, which 
> wouldn't suffer
> either the reservations issue and should be immune from the busy
> wait ...
> 


SPC-3 Section 8, of spc3r23.pdf, says W-LUN only covers
inquiry, report luns, request sense, and test unit ready.

I couldn't find where it says it worked for mode page 18h,
protocol-specfic lu page.

Eric
