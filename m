From: Steven Dake <sdake@mvista.com>
Subject: Re: iSCSI HBA needs to have a unique host id
Date: Fri, 14 Nov 2003 10:12:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068829950.4781.74.camel@persist.az.mvista.com>
References: <009d01c3aa95$9d613b70$a0074d0a@apac.cisco.com>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rav-az.mvista.com ([65.200.49.157]:46129 "EHLO
	zipcode.az.mvista.com") by vger.kernel.org with ESMTP
	id S264582AbTKNRMj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 12:12:39 -0500
In-Reply-To: <009d01c3aa95$9d613b70$a0074d0a@apac.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: "Surekha.PC" <surekhap@cisco.com>
Cc: linux-scsi@vger.kernel.org


On Fri, 2003-11-14 at 02:56, Surekha.PC wrote:
> Hi all,
> 
>    The host id for iSCSI HBA does not remain unique with  2.6 linux
> kernel. It keeps changing when iSCSI host is added and removed
> dynamically. This is a problem for persistent device naming for iSCSI
> devices through host id.
> 
Surekha,

Persistent device naming should be handled through userspace application
so that the policy of the device naming is more controllable.  I suggest
examining the uSDE project www.sourceforge.net/projects/usde for an
example implementation.  In this case, target disks can be persistently
named by their unique IEEE identifier and HBAs can be persistently named
by their PCI slot path address.  These are only sample policies that
could be implemented..  The usde framework allows for any policy to be
implemented.

Thanks
-steve


> It would be good to maintain a database of already allocated host id's
> for the existing hosts. This would render the iSCSI HBA to get the same
> controller id, irrespective of loading/unloading the driver repeatedly.
>  
> Would like to know if there is any provision in 2.6 to achieve the
> above?
> 
> thanks,
> surekha 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

