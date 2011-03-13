From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: Re: [PATCH 0/2] ISCSID: Added vlan field to the iface struct
Date: Sun, 13 Mar 2011 14:44:59 -0700
Message-ID: <1300052700.9768.44.camel@ltirv-waie-lx1>
References: <eddie.wai@broadcom.com>
 <1299810073-7339-1-git-send-email-eddie.wai@broadcom.com>
 <4D7C7C36.2040206@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1743 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883Ab1CMVpQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Mar 2011 17:45:16 -0400
In-Reply-To: <4D7C7C36.2040206@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, James Bottomley <JBottomley@novell.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Benjamin Li <benli@broadcom.com>

On Sun, 2011-03-13 at 00:11 -0800, Mike Christie wrote:
> On 03/10/2011 08:21 PM, Eddie Wai wrote:
> > Hello,
> >
> > This patch adds the iface.vlan field to the iface struct so that it
> > can be defined in the iface file.
> 
> Does qlogic's patches do what you wanted? Please review those patches 
> and work with them to figure out what works for both of you guys.
> 
Yes, I think the overall strategy to send the transport the new net
params info for the offload adapter will work for our offload solution
as well.  Some of the parameters like vlan is exactly how we want it to
be sent down.  Others like subnetmask/gateway/etc. will have to be
parsed by uIP directly from the iface file instead.

All in all, it will work for us. Thanks.


