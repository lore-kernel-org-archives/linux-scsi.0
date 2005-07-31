From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [ANNOUNCE 0/7] Open-iSCSI/Linux-iSCSI-5 High-Performance
 Initiator
Date: Sat, 30 Jul 2005 17:33:52 -0700 (PDT)
Message-ID: <20050730.173352.41656851.davem@davemloft.net>
References: <20050730.125312.78734701.davem@davemloft.net>
	<1122755000.5055.31.camel@mulgrave>
	<1122758728.13559.4.camel@mylaptop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-168.sfo1.dsl.speakeasy.net ([216.27.180.168]:19893
	"EHLO sunset.davemloft.net") by vger.kernel.org with ESMTP
	id S263136AbVGaAds (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Jul 2005 20:33:48 -0400
In-Reply-To: <1122758728.13559.4.camel@mylaptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dmitry_yus@yahoo.com
Cc: James.Bottomley@SteelEye.com, itn780@yahoo.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de

From: Dmitry Yusupov <dmitry_yus@yahoo.com>
Date: Sat, 30 Jul 2005 14:25:28 -0700

> It would be nice to set MAX_LINKS to 64 and close this issue for now,

James and Dmitry, increasing MAX_LINKS does't work, did you actually
try to open a netlink socket with a protocol number larger than 32?

It will not work.  Don't you think I'd implement such a simple fix to
expand the protocol number space if it was that easy? :-)

You can't increase MAX_LINKS past 32 because this is also the value of
NPROTO.  It is impossible to create a new socket with a protocol value
larger than NPROTO, and this value is exported into userspace as well.
