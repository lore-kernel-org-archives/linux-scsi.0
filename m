From: Naveen Burmi <naveenb@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Thu, 20 Nov 2003 19:02:06 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03112019020601.16789@naveenb-lnx.cisco.com>
References: <200310231734.10263.krmurthy@cisco.com> <03111920183201.15831@naveenb-lnx.cisco.com> <20031119091717.A11499@beaverton.ibm.com>
Reply-To: naveenb@cisco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:50877 "EHLO
	sj-iport-2.cisco.com") by vger.kernel.org with ESMTP
	id S261812AbTKTN3C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 08:29:02 -0500
In-Reply-To: <20031119091717.A11499@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Wednesday 19 November 2003 10:47 pm, Patrick Mansfield wrote:

Lun masking feature is provided by the linux-iscsi driver. In the linux-iscsi 
driver configuration file user can specify the luns of a target that needs to 
be activated upon the detection of that target.

> If you already have the LUN specified, why do you need to issue a REPORT
> LUN command?

User has specified the LUNs that needs to be activated upon the detection of 
a target. Once that target gets detected then to find out weather the LUNs 
specified by the user are actually present, we need to issue REPORT LUN 
command.
 
>
> I don't know iSCSI specification details, but I would want to specify a
> target, not a LUN, in a configuration file and have all LUNs on the target
> be automatically configured.
>

User might not want to configure all the LUNs of a target. 

> The iSCSI target itself, or actual storage (if iSCSI is just passing
> through commands to an actual disk drive) could control what LUNs are seen
> by an individual host.
>
> -- Patrick Mansfield

Naveen
