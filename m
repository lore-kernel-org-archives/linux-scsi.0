From: Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.11-mm4: drivers/scsi/arcmsr/arcmsr.c: enormous stack usage
Date: Tue, 22 Mar 2005 16:56:55 +0100
Message-ID: <20050322155655.GC1948@stusta.de>
References: <20050316040654.62881834.akpm@osdl.org> <20050319133951.GK3143@stusta.de> <002c01c52df4$37620cd0$9300a8c0@erich2003>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:32263 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261383AbVCVP45 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2005 10:56:57 -0500
Content-Disposition: inline
In-Reply-To: <002c01c52df4$37620cd0$9300a8c0@erich2003>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: erich <erich@areca.com.tw>
Cc: linux-scsi@vger.kernel.org, Linux Matt Dainty <matt@bodgit-n-scarper.com>, Linux Kornel Wieliczek <e0815w@onlinehome.de>, Linux James Bottomley <James.Bottomley@SteelEye.com>, Linux Christoph Hellwig <hch@infradead.org>, Linux Arjan van de Ven <arjan@infradead.org>, Linux Andrew Morton <akpm@osdl.org>

On Mon, Mar 21, 2005 at 04:58:57PM +0800, erich wrote:

> Hi Dear All

Hi,

> I had modify  arcmsr_iop_ioctlcmd data buffer allocations from the stack
> issue.
>...

thanks, but an additional stack issue is still present (it's a bit more 
hidden):
- cmdioctlfld uses 1060 bytes from the stack

> Best Regards
> Erich Chen

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

