From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [2.6 patch] SCSI aic7xxx: kill kernel 2.2 #ifdef's (fwd)
Date: Thu, 16 Dec 2004 17:20:24 -0800
Message-ID: <41C23458.1080404@osdl.org>
References: <20041216221802.GT12937@stusta.de>  <41C2147D.1090603@osdl.org> <1103239700.21806.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:64139 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262712AbULQBZU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Dec 2004 20:25:20 -0500
In-Reply-To: <1103239700.21806.40.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Alan Cox wrote:
>>I would really appreciate it if you could limit patches for major
>>subsystems to only the mailing list for those subsystems.
> 
> 
> And then I'd have missed the lapb error for example. At least for less
> maintained stuff do use this list

netdev is _the_ mailing list for network-related development...

scsi should happen on linux-scsi

If we take your argument to an extreme, we only need
one mailing list.  :(

-- 
~Randy
