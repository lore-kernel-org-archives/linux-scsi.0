From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [ANNOUNCE 4/7] open-iscsi/linux-iscsi-5 Initiator:
	open-iscsi-netlink.patch
Date: Thu, 04 Aug 2005 22:22:33 -0500
Message-ID: <1123212153.5026.90.camel@mulgrave>
References: <42F2CF76.3040209@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:27849 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262828AbVHEDXM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2005 23:23:12 -0400
In-Reply-To: <42F2CF76.3040209@yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex Aizman <itn780@yahoo.com>
Cc: "David S. Miller" <davem@davemloft.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Thu, 2005-08-04 at 19:31 -0700, Alex Aizman wrote:
> +#define NETLINK_ISCSI		31	/* iSCSI Open Interface */

This isn't exactly what Dave Miller said to do last time.  This one
can't go in until he OK's it.

James


