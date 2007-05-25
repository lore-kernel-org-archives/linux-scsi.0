From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] s390 error: implicit declaration of function sg_dma_len
Date: Fri, 25 May 2007 02:13:03 -0700 (PDT)
Message-ID: <20070525.021303.70218696.davem@davemloft.net>
References: <20070525082238.GA30876@aepfle.de>
	<4656A778.2000403@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47518
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750890AbXEYJM7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 May 2007 05:12:59 -0400
In-Reply-To: <4656A778.2000403@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: olaf@aepfle.de, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

From: Hannes Reinecke <hare@suse.de>
Date: Fri, 25 May 2007 11:08:08 +0200

> James, please apply. ESP cards simply don't fit in a mainframe :-)

No James, please don't, I have a patch in my sparc-2.6 queue which
will fix this already, and in a different way.
