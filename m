From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 19 Nov 2003 09:17:17 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031119091717.A11499@beaverton.ibm.com>
References: <200310231734.10263.krmurthy@cisco.com> <20031027153932.A16679@infradead.org> <03111920183201.15831@naveenb-lnx.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:28830 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S263953AbTKSRSM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 12:18:12 -0500
Content-Disposition: inline
In-Reply-To: <03111920183201.15831@naveenb-lnx.cisco.com>; from naveenb@cisco.com on Wed, Nov 19, 2003 at 08:18:32PM +0530
List-Id: linux-scsi@vger.kernel.org
To: Naveen Burmi <naveenb@cisco.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Wed, Nov 19, 2003 at 08:18:32PM +0530, Naveen Burmi wrote:

> After a device gets detected by iSCSI LLD, it uses iscsi_do_cmnd to send scsi 
> commands to that device even before registering it with the scsi mid-layer.
>  
> For example user can configure in iscsi LLD configuration (iscsi.conf) file 
> what various LUNs of a particular target needs to be activated. To acheive 
> this we need to execute REPORT LUN command on target, to find out what 
> various luns are present and selectively issue scsi_add_device for luns that 
> needs to be activated.

If you already have the LUN specified, why do you need to issue a REPORT
LUN command?

I don't know iSCSI specification details, but I would want to specify a
target, not a LUN, in a configuration file and have all LUNs on the target
be automatically configured.

The iSCSI target itself, or actual storage (if iSCSI is just passing
through commands to an actual disk drive) could control what LUNs are seen
by an individual host.

-- Patrick Mansfield
