From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sym53c8xx: fix NULL pointer dereference panic in sym_int_sir() in sym_hipd.c
Date: Tue, 11 Sep 2018 20:55:34 -0400
Message-ID: <yq1o9d3y1o9.fsf@oracle.com>
References: <1535557096-1324-1-git-send-email-george.kennedy@oracle.com>
        <CAHp75Vc=Fg165nL+SFDXXDzBvtba+C7CLK24gyz3EaAb8QdjNQ@mail.gmail.com>
        <CAFhKne_MtbSKXTT2e+CXZGs_uVieqsfX2ODc8hc5ptdAn8_ETg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFhKne_MtbSKXTT2e+CXZGs_uVieqsfX2ODc8hc5ptdAn8_ETg@mail.gmail.com>
        (Matthew Wilcox's message of "Thu, 30 Aug 2018 09:40:28 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy6545@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, george.kennedy@oracle.com, Matthew Wilcox <matthew@wil.cx>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Matthew,

> I don't think that's worth doing. Let's keep the patch simple like
> this.

Applied to 4.20/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
