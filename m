From: KY Srinivasan <kys@microsoft.com>
Subject: RE: Drivers: scsi: FLUSH timeout
Date: Wed, 2 Oct 2013 18:29:00 +0000
Message-ID: <ff6a93ed5d234c14874d03415812a3ec@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1379705547-15028-1-git-send-email-kys@microsoft.com>
 <20130920203222.GA14306@kroah.com>
 <a97d266e2c284d688d2dd7ad43f179b8@SN2PR03MB061.namprd03.prod.outlook.com>
 <524180B7.7090307@gmail.com>
 <3413dbd7fa254fd380a84fe6d9cd87e1@SN2PR03MB061.namprd03.prod.outlook.com>
 <5241C9E7.2000404@cs.wisc.edu>
 <bf168ab724a140f989ab3dfe877b750f@SN2PR03MB061.namprd03.prod.outlook.com>
 <CAMuHMdV-BsKc-c1YhzqFrUGJhw+jMZEXXTcT2xyDLnw-JQuVaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <CAMuHMdV-BsKc-c1YhzqFrUGJhw+jMZEXXTcT2xyDLnw-JQuVaQ@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, "ohering@suse.com" <ohering@suse.com>, Jack Wang <xjtuwjp@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: geert.uytterhoeven@gmail.com [mailto:geert.uytterhoeven@gmail.com]
> On Behalf Of Geert Uytterhoeven
> Sent: Wednesday, September 25, 2013 1:40 AM
> To: KY Srinivasan
> Cc: Mike Christie; Jack Wang; Greg KH; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> hch@infradead.org; linux-scsi@vger.kernel.org
> Subject: Re: Drivers: scsi: FLUSH timeout
> 
> On Tue, Sep 24, 2013 at 11:53 PM, KY Srinivasan <kys@microsoft.com> wrote:
> > I am not sure how that magic number was arrived at (the 60HZ number). We
> want this to be little higher -
> 
> "60 * HZ" means "60 seconds".
> 
> > would there be any issues raising this to say  180 seconds. This is the value we
> currently have for I/O
> > timeout.
> 
> So you want to replace it by "180 * HZ", which is ... another magic number?

Ideally, I want this to be adjustable like the way we can change the I/O timeout.
Since that has been attempted earlier and rejected (not clear what the reasons were),
I was suggesting that we pick a larger number. James, let me know how I should proceed here.

Regards,

K. Y
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
