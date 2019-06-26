From: "Alastair D'Silva" <alastair@d-silva.org>
Subject: Re: [PATCH v4 0/7] Hexdump Enhancements
Date: Wed, 26 Jun 2019 11:02:29 +1000
Message-ID: <e16caf5b98aafea4033bfc0e49845ef987c02678.camel@d-silva.org>
References: <20190625031726.12173-1-alastair@au1.ibm.com>
         <3ae4c1a4a72f8ee6b75c45adfbe543fc0a7b5da1.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <3ae4c1a4a72f8ee6b75c45adfbe543fc0a7b5da1.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Dan Carpenter <dan.carpenter@oracle.com>, Karsten Keil <isdn@linux-pingi.de>, Jassi Brar <jassisinghbrar@gmail.com>, Tom Lendacky <thomas.lendacky@amd.com>, "David S. Miller" <davem@davemloft.net>, Jose Abreu <Jose.Abreu@synopsys.com>, Kalle Valo <kvalo@codeaurora.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Benson Leung <bleung@chromium.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexa
List-Id: linux-scsi@vger.kernel.org

On Mon, 2019-06-24 at 22:01 -0700, Joe Perches wrote:
> On Tue, 2019-06-25 at 13:17 +1000, Alastair D'Silva wrote:
> > From: Alastair D'Silva <alastair@d-silva.org>
> > 
> > Apologies for the large CC list, it's a heads up for those
> > responsible
> > for subsystems where a prototype change in generic code causes a
> > change
> > in those subsystems.
> []
> > The default behaviour of hexdump is unchanged, however, the
> > prototype
> > for hex_dump_to_buffer() has changed, and print_hex_dump() has been
> > renamed to print_hex_dump_ext(), with a wrapper replacing it for
> > compatibility with existing code, which would have been too
> > invasive to
> > change.
> 
> I believe this cover letter is misleading.
> 
> The point of the wrapper is to avoid unnecessary changes
> in existing
> code.
> 
> 

The wrapper is for print_hex_dump(), which has many callers.

The changes to existing code are for hex_dump_to_buffer(), which is
called in relatively few places.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva    
Twitter: @EvilDeece
blog: http://alastair.d-silva.org
