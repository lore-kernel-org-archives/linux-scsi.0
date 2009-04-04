From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] [SCSI] qlogicpti: use request_firmware
Date: Sat, 04 Apr 2009 16:37:42 -0700 (PDT)
Message-ID: <20090404.163742.02838692.davem@davemloft.net>
References: <1238703170.3099.90.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42983
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754195AbZDDXhx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Apr 2009 19:37:53 -0400
In-Reply-To: <1238703170.3099.90.camel@ht.satnam>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaswinder@kernel.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dwmw2@infradead.org, sfr@canb.auug.org.au

From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Date: Fri, 03 Apr 2009 01:42:50 +0530

> Firmware blob is little endian
> 
> Thanks to Stephen Rothwell for fixing typos
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

This looks fine to me.
