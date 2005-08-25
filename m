From: Suparna Bhattacharya <suparna@in.ibm.com>
Subject: Re: Some interesting results in the aic7xxx slowdown problem
Date: Thu, 25 Aug 2005 16:09:43 +0530
Message-ID: <20050825103943.GA7421@in.ibm.com>
References: <1123119347.5019.78.camel@mulgrave> <20050804061809.GA4158@in.ibm.com> <1123166928.5026.8.camel@mulgrave> <20050819095428.GA9130@in.ibm.com> <1124457765.5130.13.camel@mulgrave>
Reply-To: suparna@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:26790 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S964943AbVHYLm2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Aug 2005 07:42:28 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j7PBfxsC026996
	for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2005 07:42:12 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7PAUX8a263498
	for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2005 06:30:33 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j7PAUWET018671
	for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2005 06:30:33 -0400
Content-Disposition: inline
In-Reply-To: <1124457765.5130.13.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Aug 19, 2005 at 09:22:45AM -0400, James Bottomley wrote:
> On Fri, 2005-08-19 at 15:24 +0530, Suparna Bhattacharya wrote:
> >  sda:
> 
> Well, this line is identifying the root cause.  It says that the
> partition code came up with no partitions for this device.  Do any of
> your other devices come up with paritions? (as in could this be a simple
> device node transposition issue?)

Yes, it looks like that. The ordering now seems to be id 9, 10, ... 14, 0,
1, 2, instead of the default of id 0, 1, 2 ...  Did you expect a change
in probe ordering ? 

When I switch back to the old AIC driver the ordering goes back to
default.


Regards
Suparna

> 
> James
> 
> 

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

