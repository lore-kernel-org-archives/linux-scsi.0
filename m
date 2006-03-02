From: "Quat Le" <Quat.Le@dothill.com>
Subject: RE: ATA Pass-Through support
Date: Thu, 2 Mar 2006 10:41:47 -0800
Message-ID: <DF9C50EF9E8CDA45A06FE8735C68F85E569309@earthex2.power.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 17.129.dothill.com ([155.254.129.17]:35690 "EHLO
	earthex1.dothill.com") by vger.kernel.org with ESMTP
	id S1751648AbWCBSlv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2006 13:41:51 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Moore, Eric" <Eric.Moore@lsil.com>, dougg@torque.net, linux-scsi@vger.kernel.org, Brian King <brking@us.ibm.com>, linux-ide@vger.kernel.org

> -----Original Message-----
> From: Jeff Garzik [mailto:jgarzik@pobox.com]
> Sent: Thursday, March 02, 2006 10:17 AM
> To: Quat Le
> Cc: Moore, Eric; dougg@torque.net; linux-scsi@vger.kernel.org; Brian
King;
> linux-ide@vger.kernel.org
> Subject: Re: ATA Pass-Through support
> 
> Brian King, maintainer of the ipr driver, has posted patches which
> integrate libata SATA support into his driver.  Merging those is on my
> todo list, though I'm currently waiting on Tejun Heo's error handling
> work before tackling that (and NCQ and hotplug...).
> 
> 	Jeff
>

Jeff,
I'm not familiar with the ipr driver. Is this for IBM PowerPC RAID? How
will this work for me? I don't really need RAID. What I have is a
Pentium-based machine.  I want to be able to talk to SATA drives on a
SAS expander.
 

