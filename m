From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [ANNOUNCE 4/7] open-iscsi/linux-iscsi-5 Initiator:
 open-iscsi-netlink.patch
Date: Thu, 4 Aug 2005 21:13:02 -0700
Message-ID: <20050804211302.754ba34f.rdunlap@xenotime.net>
References: <42F2CF76.3040209@yahoo.com>
	<1123212153.5026.90.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:46732 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S262854AbVHEENF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2005 00:13:05 -0400
Received: from midway ([71.111.147.75]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 4 Aug 2005 21:13:04 -0700
In-Reply-To: <1123212153.5026.90.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: itn780@yahoo.com, davem@davemloft.net, linux-scsi@vger.kernel.org, hch@lst.de

On Thu, 04 Aug 2005 22:22:33 -0500 James Bottomley wrote:

> On Thu, 2005-08-04 at 19:31 -0700, Alex Aizman wrote:
> > +#define NETLINK_ISCSI		31	/* iSCSI Open Interface */
> 
> This isn't exactly what Dave Miller said to do last time.  This one
> can't go in until he OK's it.

Alex-
for reference, see
http://marc.theaimsgroup.com/?l=linux-scsi&m=112275607106857&w=2
and then follow [next in thread]


---
~Randy
