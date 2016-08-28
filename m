From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 1/3] documentation/scsi: Remove nodisconnect parameter
Date: Sun, 28 Aug 2016 10:07:13 +0200
Message-ID: <CAMuHMdUTwL8HoPk=YEuYYucEiUgpNJ_Hho8Duo0MOiTbP8WE+w@mail.gmail.com>
References: <20160827022958.983743612@telegraphics.com.au> <20160827022959.119870978@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160827022959.119870978@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 27, 2016 at 4:29 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> The driver that used the 'nodisconnect' parameter was removed in
> commit 565bae6a4a8f ("[SCSI] 53c7xx: kill driver"). Related documentation
> was cleaned up in commit f37a7238d379 ("[SCSI] 53c7xx: fix removal
> fallout"), except for the remaining two mentions that are removed here.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
