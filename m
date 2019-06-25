From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v4 4/7] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
Date: Mon, 24 Jun 2019 22:17:40 -0700
Message-ID: <45177fdaff2bf2a2538e34dab175488d2ba9a46c.camel@perches.com>
References: <20190625031726.12173-1-alastair@au1.ibm.com>
         <20190625031726.12173-5-alastair@au1.ibm.com>
         <3340b520a57e00a483eae170be97316c8d18c22c.camel@perches.com>
         <746098160c4ff6527d573d2af23c403b6d4e5b80.camel@d-silva.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <746098160c4ff6527d573d2af23c403b6d4e5b80.camel@d-silva.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alastair D'Silva <alastair@d-silva.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Dan Carpenter <dan.carpenter@oracle.com>, Karsten Keil <isdn@linux-pingi.de>, Jassi Brar <jassisinghbrar@gmail.com>, Tom Lendacky <thomas.lendacky@amd.com>, "David S. Miller" <davem@davemloft.net>, Jose Abreu <Jose.Abreu@synopsys.com>, Kalle Valo <kvalo@codeaurora.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Benson Leung <bleung@chromium.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexa
List-Id: linux-scsi@vger.kernel.org

On Tue, 2019-06-25 at 15:06 +1000, Alastair D'Silva wrote:
> On Mon, 2019-06-24 at 22:01 -0700, Joe Perches wrote:
> > On Tue, 2019-06-25 at 13:17 +1000, Alastair D'Silva wrote:
> > > From: Alastair D'Silva <alastair@d-silva.org>
> > > 
> > > In order to support additional features, rename hex_dump_to_buffer
> > > to
> > > hex_dump_to_buffer_ext, and replace the ascii bool parameter with
> > > flags.
> > []
> > > diff --git a/drivers/gpu/drm/i915/intel_engine_cs.c
> > > b/drivers/gpu/drm/i915/intel_engine_cs.c
> > []
> > > @@ -1338,9 +1338,8 @@ static void hexdump(struct drm_printer *m,
> > > const void *buf, size_t len)
> > >  		}
> > >  
> > >  		WARN_ON_ONCE(hex_dump_to_buffer(buf + pos, len - pos,
> > > -						rowsize, sizeof(u32),
> > > -						line, sizeof(line),
> > > -						false) >=
> > > sizeof(line));
> > > +						rowsize, sizeof(u32),
> > > line,
> > > +						sizeof(line)) >=
> > > sizeof(line));
> > 
> > Huh?  Why do this?
[]
> The change actions Jani's suggestion:
> https://lkml.org/lkml/2019/6/20/343

I think you need to read this change again.
