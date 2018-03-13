From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: Re: [PATCH] scsi: eata: drop VLA in reorder()
Date: Tue, 13 Mar 2018 23:04:21 +0100
Message-ID: <CAJHCu1+XPPmCcrP+89zc9Lg7k_t78LzfJbY7aC8Mt+ANeuVWdA@mail.gmail.com>
References: <1520802418-17284-1-git-send-email-s.mesoraca16@gmail.com>
 <20180312030834.GC8631@eros> <CA+55aFww=otC4Wv40enadF+9NAyWG4Hotzjvv2EKb+_wGFui-w@mail.gmail.com>
 <yq1y3iwem87.fsf@oracle.com> <20180313090540.GA4810@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180313090540.GA4810@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Tobin C. Harding" <tobin@apporbit.com>, Arthur Marsh <arthur.marsh@internode.on.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Dario Ballabio <ballabio_dario@emc.com>, Kees Cook <keescook@chromium.org>, kernelnewbies@kernelnewbies.org
List-Id: linux-scsi@vger.kernel.org

2018-03-13 10:05 GMT+01:00 Christoph Hellwig <hch@infradead.org>:
> On Mon, Mar 12, 2018 at 10:35:36PM -0400, Martin K. Petersen wrote:
>> No objections to Salvatore's patch but I have a slight affinity for
>> retiring unused code over patching it. So unless there are objections...
>
> Lets kill it.  And the not DMA capable eata_pio driver with it for
> good riddance.

Good, I'll send a patch to remove eata & friends.
Thank you for your time,

Salvatore
