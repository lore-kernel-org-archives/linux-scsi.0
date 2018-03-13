From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: eata: drop VLA in reorder()
Date: Tue, 13 Mar 2018 02:05:40 -0700
Message-ID: <20180313090540.GA4810@infradead.org>
References: <1520802418-17284-1-git-send-email-s.mesoraca16@gmail.com>
 <20180312030834.GC8631@eros>
 <CA+55aFww=otC4Wv40enadF+9NAyWG4Hotzjvv2EKb+_wGFui-w@mail.gmail.com>
 <yq1y3iwem87.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1y3iwem87.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Tobin C. Harding" <tobin@apporbit.com>, Arthur Marsh <arthur.marsh@internode.on.net>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Dario Ballabio <ballabio_dario@emc.com>, Kees Cook <keescook@chromium.org>, kernelnewbies@kernelnewbies.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 12, 2018 at 10:35:36PM -0400, Martin K. Petersen wrote:
> No objections to Salvatore's patch but I have a slight affinity for
> retiring unused code over patching it. So unless there are objections...

Lets kill it.  And the not DMA capable eata_pio driver with it for
good riddance.

> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
---end quoted text---
