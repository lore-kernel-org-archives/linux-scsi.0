From: Robert Gadsdon <robert@gadsdon.giointernet.co.uk>
Subject: Re: [RFC] killing the AMD53C974 and mac_NCR5380 drivers
Date: Sun, 01 Feb 2004 16:39:58 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <401D2BDE.4020807@gadsdon.giointernet.co.uk>
References: <fa.e2hfjs3.q3e2i3@ifi.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <fa.e2hfjs3.q3e2i3@ifi.uio.no>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I always had problems with the AMD53C974 driver even back in 2.2.x days. 
  On several old HP XU/90 and XU/120 Vectras I had to specify the 
TMSCSIM driver to get SCSI to work.....

Robert Gadsdon.

Christoph Hellwig wrote:
> Anyone screaming loudly if we remove them?
> 
>  - AMD53C974 is broken and doesn't even compile, all supported hardware is
>    handled by the mainted tmscsim driver.
>  - mac_NCR5380 isn't even referenced in the build and hasn't been at
>    least since 2.4
>                            
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
