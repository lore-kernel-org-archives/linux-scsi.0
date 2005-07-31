From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [ANNOUNCE 0/7] Open-iSCSI/Linux-iSCSI-5 High-Performance
 Initiator
Date: Sat, 30 Jul 2005 17:34:53 -0700 (PDT)
Message-ID: <20050730.173453.130210989.davem@davemloft.net>
References: <1122744762.5055.10.camel@mulgrave>
	<20050730.125312.78734701.davem@davemloft.net>
	<1122755000.5055.31.camel@mulgrave>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S263194AbVGaAfV@vger.kernel.org>
In-Reply-To: <1122755000.5055.31.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: itn780@yahoo.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Sat, 30 Jul 2005 15:23:20 -0500

> Actually, I saw this and increased MAX_LINKS as well.

That does absolutely nothing, you cannot create sockets
with protocol numbers larger than NPROTOS which like MAX_LINKS
has the value 32.  And NPROTOS is something we cannot change.
