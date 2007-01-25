From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: why no cmd_flags parameter for scsi_execute_async?
Date: Thu, 25 Jan 2007 16:34:17 -0500
Message-ID: <45B92259.20401@cs.wisc.edu>
References: <1169763544.6129.47.camel@egoggin-devd.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39253 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030642AbXAYWeU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jan 2007 17:34:20 -0500
In-Reply-To: <1169763544.6129.47.camel@egoggin-devd.eng.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Edward Goggin <egoggin@vmware.com>
Cc: linux-scsi@vger.kernel.org

Edward Goggin wrote:
> Looks like a simple oversight, but does anyone know why there a
> cmd_flags parameter for scsi_execute but not for scsi_execute_async?
> 
> Seems like this is lost functionality when scsi_execute_async replaced
> scsi_do_req.  Previously, the caller of scsi_do_req could set the flags
> field of the sr_request structure of the scsi_request parameter to the
> function.
> 
> Is scsi_execute_async being replaced as part of the bidi patch set?
> 

I am trying to kill it and covert the ulds to use requests directly.
