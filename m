From: Mark Lord <lkml@rtr.ca>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: Thu, 07 Oct 2004 11:35:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4165624C.5060405@rtr.ca>
References: <4161A06D.8010601@rtr.ca> <416547B6.5080505@rtr.ca> <20041007150709.B12688@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpu1185.adsl.bellglobal.com ([207.236.110.166]:38333 "EHLO
	mail.rtr.ca") by vger.kernel.org with ESMTP id S267319AbUJGPh2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Oct 2004 11:37:28 -0400
In-Reply-To: <20041007150709.B12688@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Lord <lsml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Which typedefs do you mean?  Most all of the original ones are gone.

And the EXPORT_SYMBOLS() have not been vetoed to my knowledge.
They're required for addtional driver extensions that are being
provided later one, as GPL'd source code.

Cheers
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
