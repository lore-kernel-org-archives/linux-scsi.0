From: David Miller <davem@davemloft.net>
Subject: Re: s390 error: implicit declaration of function sg_dma_len
Date: Fri, 25 May 2007 01:55:03 -0700 (PDT)
Message-ID: <20070525.015503.90123165.davem@davemloft.net>
References: <20070525082238.GA30876@aepfle.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46999
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbXEYIzA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 May 2007 04:55:00 -0400
In-Reply-To: <20070525082238.GA30876@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olaf@aepfle.de
Cc: linux-scsi@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>
Date: Fri, 25 May 2007 10:22:38 +0200

> Current Linus tree does not compile on s390 because esp_scsi references
> unavailable functions.

I have a fix for this pending in my sparc-2.6 tree which I'll
send to Linus tomorrow, thanks for the report.
