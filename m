From: "Alastair D'Silva" <alastair@d-silva.org>
Subject: Re: [PATCH v4 4/7] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
Date: Wed, 26 Jun 2019 11:27:53 +1000
Message-ID: <e1b3d172f07f681fed9c311dec67cfb695408f5c.camel@d-silva.org>
References: <20190625031726.12173-1-alastair@au1.ibm.com>
         <20190625031726.12173-5-alastair@au1.ibm.com>
         <3340b520a57e00a483eae170be97316c8d18c22c.camel@perches.com>
         <746098160c4ff6527d573d2af23c403b6d4e5b80.camel@d-silva.org>
         <4ba3b835fb3675ea685390903a082bf8b7f9e955.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4ba3b835fb3675ea685390903a082bf8b7f9e955.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Dan Carpenter <dan.carpenter@oracle.com>, Karsten Keil <isdn@linux-pingi.de>, Jassi Brar <jassisinghbrar@gmail.com>, Tom Lendacky <thomas.lendacky@amd.com>, "David S. Miller" <davem@davemloft.net>, Jose Abreu <Jose.Abreu@synopsys.com>, Kalle Valo <kvalo@codeaurora.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Benson Leung <bleung@chromium.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexa
List-Id: linux-scsi@vger.kernel.org

On Mon, 2019-06-24 at 22:19 -0700, Joe Perches wrote:
> On Tue, 2019-06-25 at 15:06 +1000, Alastair D'Silva wrote:
> > The change actions Jani's suggestion:
> > https://lkml.org/lkml/2019/6/20/343
> 
> I suggest not changing any of the existing uses of
> hex_dump_to_buffer and only use hex_dump_to_buffer_ext
> when necessary for your extended use cases.
> 
> 

I disagree, adding a wrapper for the benefit of avoiding touching a
handful of call sites that are easily amended would be adding technical
debt.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva    
Twitter: @EvilDeece
blog: http://alastair.d-silva.org
