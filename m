From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: Re: [PATCH 6/8] BNX2I: Added jumbo MTU support for the no shost
 case
Date: Wed, 5 Jan 2011 14:58:25 -0800
Message-ID: <1294268306.1988.97.camel@ltirv-waie-lx1>
References: <Eddie Wai <eddie.wai@broadcom.com>
 <1294260267-17413-7-git-send-email-eddie.wai@broadcom.com>
 <4D24D997.30104@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1607 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab1AEWzq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 17:55:46 -0500
In-Reply-To: <4D24D997.30104@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eddie Wai <waie@broadcom.com>, James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Benjamin Li <benli@broadcom.com>


On Wed, 2011-01-05 at 12:50 -0800, Mike Christie wrote:
> On 01/05/2011 02:44 PM, Eddie Wai wrote:
> > For scenarios where the shost is not being passed to bnx2i for the
> > iSCSI offload connection request, the code would consult the routing
> > table to select the CNIC device.
> > This code path will erroneously error out if the corresponding L2
> > interface's MTU has been setup to>  1500.
> >
> 
> When have you guys actually hit this? What tools and what version does this?
I believe we had run into this case in the past by not specifying the
ifacename parameter in a static node but use transport of bnx2i.  I
would have to go back and revisit that for verification.  But its a
scenario our driver has supports for in the past.  The jumbo MTU support
was added to the shost case a while back.  Adding this is more for
completeness.
> 


