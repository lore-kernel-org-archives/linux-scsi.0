From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6 patch] SCSI aacraid: make some code static
Date: Mon, 15 Nov 2004 14:26:31 +0000
Message-ID: <1100528774.27202.7.camel@localhost.localdomain>
References: <20041115014955.GC2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clock-tower.bc.nu ([81.2.110.250]:28642 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S261622AbUKOPbq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 10:31:46 -0500
In-Reply-To: <20041115014955.GC2249@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Llu, 2004-11-15 at 01:49, Adrian Bunk wrote:
> The patch below makes some needlessly global code static.
> 
> It also removes the completely unused global function 
> aac_consumer_avail.

Looks good to me but make sure you send a copy on to the maintainer
<mark_salyzyn@adaptec.com> as he'll want it for the development drivers
(and we want that because there are a pile of new cards 8))

