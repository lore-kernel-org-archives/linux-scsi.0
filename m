From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Adaptec SAS integration notes
Date: Sat, 15 Oct 2005 16:19:22 +0200
Message-ID: <43510FEA.6070109@s5r6.in-berlin.de>
References: <20051014180615.5604.qmail@web31808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:57239 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751152AbVJOOVO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Oct 2005 10:21:14 -0400
In-Reply-To: <20051014180615.5604.qmail@web31808.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: ltuikov@yahoo.com, Jeff Garzik <jgarzik@pobox.com>, Mike Anderson <andmike@us.ibm.com>, Luben Tuikov <luben_tuikov@adaptec.com>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, linux-ide@vger.kernel.org

Luben Tuikov wrote:
> --- Jeff Garzik <jgarzik@pobox.com> wrote:
>>(HCIL should get marginalized, as all agree)

"Marginalized" was not the term that I remember.

>>* Put HCIL mapping into top-level helper code, for sharing between FC
>>and SAS (hopefully!)
> 
> One step further: eliminate the ugly legacy SPI-centric HCIL from
> SCSI Core.  Minimise and streamline SCSI Core.

I agree. FC, SAS, USB, SBP et al do not need to _share_ some HCIL 
mapping helpers --- they and the core need to get rid of HCIL mapping 
entirely. Why spend energy on optimization of existing HCIL mappings?

usb-storage and sbp2 already implement the leanest possible HCIL mapping 
(1 logical unit to 1 H). There is only one way to make this even more 
leaner and, at the same time, cleaner.
-- 
Stefan Richter
-=====-=-=-= =-=- -====
http://arcgraph.de/sr/
