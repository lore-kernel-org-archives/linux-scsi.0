From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4] sd: Ignore sync cache failures when not supported
Date: Tue, 16 May 2017 21:08:09 -0400
Message-ID: <yq1wp9g9tom.fsf@oracle.com>
References: <1494506064-19680-1-git-send-email-thierry.escande@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1494506064-19680-1-git-send-email-thierry.escande@collabora.com>
        (Thierry Escande's message of "Thu, 11 May 2017 14:34:24 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Thierry Escande <thierry.escande@collabora.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, "Ewan D . Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Thierry,

> Some external hard drives don't support the sync command even though
> the hard drive has write cache enabled. In this case, upon suspend
> request, sync cache failures are ignored if the error code in the
> sense header is ILLEGAL_REQUEST. There's not much we can do for these
> drives, so we shouldn't fail to suspend for this error case. The drive
> may stay powered if that's the setup for the port it's plugged into.

Applied to 4.12/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
