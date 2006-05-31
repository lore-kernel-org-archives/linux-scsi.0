From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: [PATCH] aic94xx: make use of the new sas_port
Date: Wed, 31 May 2006 16:16:49 -0700
Message-ID: <1149117409.7543.96.camel@localhost.localdomain>
References: <1149048555.3545.64.camel@mulgrave.il.steeleye.com>
	 <1149104797.7543.64.camel@localhost.localdomain>
	 <447E0B78.5050700@torque.net>
	 <1149114619.7543.93.camel@localhost.localdomain>
	 <1149115036.22134.153.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:18326 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S965253AbWEaXQ4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 May 2006 19:16:56 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k4VNGsCp017068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 19:16:54 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k4VNGsvS265954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 17:16:54 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4VNGrIO018196
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 17:16:54 -0600
In-Reply-To: <1149115036.22134.153.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>, dougg@torque.net, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2006-05-31 at 17:37 -0500, James Bottomley wrote:
> On Wed, 2006-05-31 at 15:30 -0700, Alexis Bruemmer wrote:
> > sas: phy0 added to port0, phy_mask:0x1
> > [  155.328494] sas: phy1 matched wide port0
> > [  155.328499] sas: phy1 added to port0, phy_mask:0x3
> > [  155.328516] sas: phy2 matched wide port0
> > [  155.328520] sas: phy2 added to port0, phy_mask:0x7
> > [  155.328541] sas: phy3 matched wide port0
> > [  155.328548] sas: phy3 added to port0, phy_mask:0xf
> > [  155.328578] sas: DOING DISCOVERY on port 0, pid:1785
> > [  155.328917] sas: ex 5005076a00000a40 phy00:T attached:
> > 50010b9000021585
> > [  155.328996] sas: ex 5005076a00000a40 phy01:T attached:
> > 50010b9000021575
> > [  155.329081] sas: ex 5005076a00000a40 phy02:T attached:
> > 50010b900004b87e
> > [  155.329169] sas: ex 5005076a00000a40 phy03:S attached:
> > 5005076a011061c0
> 
> No.  Look again.  the first four, which are a wide port, are phys 0-3 on
> the HBA.
> 
> The second four, which have separate attached devices are phys 0-3 on
> the expander (that's what the sightly cryptic ex 5005076a00000a40 phy<n>
> means).
> 
> You can see this better in the transport class tree
> 
> James

OK, that makes more sense, thank you for explaining. 

--Alexis
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

