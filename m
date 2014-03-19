From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Pv-drivers] [PATCH 2/3] VMW_PVSCSI: Add support for I/O
 requests coalescing.
Date: Wed, 19 Mar 2014 14:56:58 -0700
Message-ID: <1395266218.2185.58.camel@dabdike.int.hansenpartnership.com>
References: <1394312380.8462.27.camel@arvindkumar-dev1.eng.vmware.com>
	 <1394571094.8462.40.camel@arvindkumar-dev1.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37047 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753469AbaCSV5A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2014 17:57:00 -0400
In-Reply-To: <1394571094.8462.40.camel@arvindkumar-dev1.eng.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arvind Kumar <arvindkumar@vmware.com>
Cc: linux-scsi@vger.kernel.org, pv-drivers@vmware.com, rmehta@vmware.com

On Tue, 2014-03-11 at 13:51 -0700, Arvind Kumar wrote:
> Fixed an issue with log message's prefix. Should have been vmw_pvscsi, was pvscsi.
> Resending. Please consider this one. Thanks!
> 
> This change allows pvscsi driver to coalesce I/O requests
> before issuing them. The number of I/O's coalesced can be
> dynamically configured based on the workload.
> 
> Signed-off-by: Rishi Mehta <rmehta@vmware.com>
> Acked-by: Arvind Kumar <arvindkumar@vmware.com>

OK, so this makes it look like Rishi Mehta is the Patch author, in which
case there should have been a 

From: Rishi Mehta <rmehta@vmware.com>

at the top.  Plus you need to add a signed-off-by not an acked-by
because you actually transmitted the patch to me (signoffs follow the
chain of transmission).

I've fixed up both of these issues, you only need to reply if my
assumptions in the fixes are wrong.

James


