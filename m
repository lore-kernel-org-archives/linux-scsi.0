From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH] Add proper module ID tables to Adaptec aic7[9x]xx drivers
Date: Thu, 07 Oct 2004 23:12:12 +0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4165950C.509@tls.msk.ru>
References: <linux.scsi.20040621161047.GD16453@master.mivlgu.local> <41644BD5.7030807@tls.msk.ru> <20041006202543.GA22794@wotan.suse.de> <4165862E.1040904@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:29537 "EHLO hobbit.corpit.ru")
	by vger.kernel.org with ESMTP id S267808AbUJGTMO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2004 15:12:14 -0400
In-Reply-To: <4165862E.1040904@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> Andi Kleen wrote:
> 
[]
>> Luben, can you just do a proper pci_id table please? You probably
>> know the requirements best.
> 
> Yes, no problem. (It'd be tricky but I'll try to augment it properly.)

Christoph Hellwig already did that, it seems --
see his post to linux-scsi dated Sep-12,
http://marc.theaimsgroup.com/?m=109500574722283

/mjt
