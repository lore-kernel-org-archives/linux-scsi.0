From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] esp: fix eh locking
Date: Wed, 22 Feb 2006 14:31:41 -0800 (PST)
Message-ID: <20060222.143141.104559322.davem@davemloft.net>
References: <20060222153615.GA23488@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20060222153615.GA23488@lst.de>
Sender: sparclinux-owner@vger.kernel.org
To: hch@lst.de
Cc: weeve@gentoo.org, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Wed, 22 Feb 2006 16:36:15 +0100

> esp_reset didn't get fixed when the EH locking changed.
> ->eh_bus_reset_handler is now called without the host lock held.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks Christoph, I'll push this fix to Linus.
