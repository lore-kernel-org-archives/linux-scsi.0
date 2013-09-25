From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Drivers: scsi: FLUSH timeout
Date: Wed, 25 Sep 2013 10:40:24 +0200
Message-ID: <CAMuHMdV-BsKc-c1YhzqFrUGJhw+jMZEXXTcT2xyDLnw-JQuVaQ@mail.gmail.com>
References: <1379705547-15028-1-git-send-email-kys@microsoft.com>
	<20130920203222.GA14306@kroah.com>
	<a97d266e2c284d688d2dd7ad43f179b8@SN2PR03MB061.namprd03.prod.outlook.com>
	<524180B7.7090307@gmail.com>
	<3413dbd7fa254fd380a84fe6d9cd87e1@SN2PR03MB061.namprd03.prod.outlook.com>
	<5241C9E7.2000404@cs.wisc.edu>
	<bf168ab724a140f989ab3dfe877b750f@SN2PR03MB061.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bf168ab724a140f989ab3dfe877b750f@SN2PR03MB061.namprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Jack Wang <xjtuwjp@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 24, 2013 at 11:53 PM, KY Srinivasan <kys@microsoft.com> wrote:
> I am not sure how that magic number was arrived at (the 60HZ number). We want this to be little higher -

"60 * HZ" means "60 seconds".

> would there be any issues raising this to say  180 seconds. This is the value we currently have for I/O
> timeout.

So you want to replace it by "180 * HZ", which is ... another magic number?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
