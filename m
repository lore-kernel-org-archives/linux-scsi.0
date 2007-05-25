From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] s390 error: implicit declaration of function sg_dma_len
Date: Fri, 25 May 2007 02:13:33 -0700 (PDT)
Message-ID: <20070525.021333.102771494.davem@davemloft.net>
References: <20070525082238.GA30876@aepfle.de>
	<4656A778.2000403@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47525
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbXEYJN3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 May 2007 05:13:29 -0400
In-Reply-To: <4656A778.2000403@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: olaf@aepfle.de, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

From: Hannes Reinecke <hare@suse.de>
Date: Fri, 25 May 2007 11:08:08 +0200

> -       depends on SCSI
> +       depends on SCSI && !S390

And for the record, the correct test would be HAS_DMA not
!S390.
