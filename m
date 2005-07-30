From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [ANNOUNCE 0/7] Open-iSCSI/Linux-iSCSI-5 High-Performance
 Initiator
Date: Sat, 30 Jul 2005 12:53:54 -0700 (PDT)
Message-ID: <20050730.125354.112595635.davem@davemloft.net>
References: <1122744762.5055.10.camel@mulgrave>
	<42EBC8A6.7030403@yahoo.com>
	<20050730183803.GA12081@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S263131AbVG3TzO@vger.kernel.org>
In-Reply-To: <20050730183803.GA12081@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@lst.de
Cc: itn780@yahoo.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: Re: [ANNOUNCE 0/7] Open-iSCSI/Linux-iSCSI-5 High-Performance Initiator
Date: Sat, 30 Jul 2005 20:38:03 +0200

> On Sat, Jul 30, 2005 at 11:36:22AM -0700, Alex Aizman wrote:
> > OK. Hopefully that'll remain.
> 
> Please ask davem for a netlink number allocation.

There are none to allocate, see my other email as to how we
have to start handling the issue of many new netlink users
and the fact that we are out of numbers to give to people.
