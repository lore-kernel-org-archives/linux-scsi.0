From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ANNOUNCE 0/7] Open-iSCSI/Linux-iSCSI-5 High-Performance Initiator
Date: Sat, 06 Aug 2005 22:46:53 +0200
Message-ID: <42F521BD.9020607@trash.net>
References: <1122744762.5055.10.camel@mulgrave>	<20050730.125312.78734701.davem@davemloft.net>	<1122755000.5055.31.camel@mulgrave> <20050730.173453.130210989.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p54A0BC0C.dip0.t-ipconnect.de ([84.160.188.12]:60923 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S261151AbVHFUrH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Aug 2005 16:47:07 -0400
In-Reply-To: <20050730.173453.130210989.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
Cc: James.Bottomley@SteelEye.com, itn780@yahoo.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de

David S. Miller wrote:
> From: James Bottomley <James.Bottomley@SteelEye.com>
> Date: Sat, 30 Jul 2005 15:23:20 -0500
> 
>>Actually, I saw this and increased MAX_LINKS as well.
> 
> That does absolutely nothing, you cannot create sockets
> with protocol numbers larger than NPROTOS which like MAX_LINKS
> has the value 32.  And NPROTOS is something we cannot change.

I couldn't find any relationship between MAX_LINKS and NPROTO. NPROTO is
the maximum number of protocol families, the only limitation for
MAX_LINKS seems to be the size of sk_protocol which is an unsigned char.
So I think we can safely increase it.
