From: "Reilley, Peter" <Peter.Reilley@netapp.com>
Subject: RE: How to map between /dev/sdX and dev/sgX devices?
Date: Thu, 19 Aug 2004 15:18:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <C8CF60CFC4D8A74E9945E32CF096548A022148EE@silver.nane.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx01.netapp.com ([198.95.226.53]:28368 "EHLO mx01.netapp.com")
	by vger.kernel.org with ESMTP id S267291AbUHSTSu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 15:18:50 -0400
Received: from frejya.corp.netapp.com (frejya [10.57.157.119])
	by mx01.netapp.com (8.12.10/8.12.10/NTAP-1.4) with ESMTP id i7JJImFC000087
	for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2004 12:18:48 -0700 (PDT)
Received: from svlexc01.hq.netapp.com (svlexc01.corp.netapp.com [10.57.156.135])
	by frejya.corp.netapp.com (8.12.9/8.12.9/NTAP-1.5) with ESMTP id i7JJIlkh009721
	for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2004 12:18:48 -0700 (PDT)
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: Arjan van de Ven [mailto:arjanv@redhat.com]
> Sent: Thursday, August 19, 2004 3:13 PM
> To: Reilley, Peter
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: How to map between /dev/sdX and dev/sgX devices?
> 
> 
> On Thu, 2004-08-19 at 20:35, Reilley, Peter wrote:
> > What is the correct way to find the corresponding scsi generic
> > device given the scsi disk node name?   I have a situation
> > where I must issue SCSI pass thru commands to a specific
> > /dev/sdX node.  
> 
> don't..... use SG_IO on the device directly
> 

I don't think that this will work for me.
I must support the 2.4 kernel as well as the 2.6 kernel.

Thanks,
Pete.
