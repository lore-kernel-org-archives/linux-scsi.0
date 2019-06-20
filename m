From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v3 0/7] Hexdump Enhancements
Date: Wed, 19 Jun 2019 17:35:01 -0700
Message-ID: <d8316be322f33ea67640ff83f2248fe433078407.camel@perches.com>
References: <20190617020430.8708-1-alastair@au1.ibm.com>
         <9a000734375c0801fc16b71f4be1235f9b857772.camel@perches.com>
         <c68cb819257f251cbb66f8998a95c31cebe2d72e.camel@d-silva.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <c68cb819257f251cbb66f8998a95c31cebe2d72e.camel@d-silva.org>
Sender: netdev-owner@vger.kernel.org
To: Alastair D'Silva <alastair@d-silva.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Dan Carpenter <dan.carpenter@oracle.com>, Karsten Keil <isdn@linux-pingi.de>, Jassi Brar <jassisinghbrar@gmail.com>, Tom Lendacky <thomas.lendacky@amd.com>, "David S. Miller" <davem@davemloft.net>, Jose Abreu <Jose.Abreu@synopsys.com>, Kalle Valo <kvalo@codeaurora.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Benson Leung <bleung@chromium.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexa
List-Id: linux-scsi@vger.kernel.org

On Thu, 2019-06-20 at 09:15 +1000, Alastair D'Silva wrote:
> On Wed, 2019-06-19 at 09:31 -0700, Joe Perches wrote:
> > On Mon, 2019-06-17 at 12:04 +1000, Alastair D'Silva wrote:
> > > From: Alastair D'Silva <alastair@d-silva.org>
> > > 
> > > Apologies for the large CC list, it's a heads up for those
> > > responsible
> > > for subsystems where a prototype change in generic code causes a
> > > change
> > > in those subsystems.
> > > 
> > > This series enhances hexdump.
> > 
> > Still not a fan of these patches.
> 
> I'm afraid there's not too much action I can take on that, I'm happy to
> address specific issues though.
> 
> > > These improve the readability of the dumped data in certain
> > > situations
> > > (eg. wide terminals are available, many lines of empty bytes exist,
> > > etc).

I think it's generally overkill for the desired uses.

> > Changing hexdump's last argument from bool to int is odd.
> > 
> 
> Think of it as replacing a single boolean with many booleans.

I understand it.  It's odd.

I would rather not have a mixture of true, false, and apparently
random collections of bitfields like 0xd or 0b1011 or their
equivalent or'd defines.


> There's only a handful of consumers, I don't think there is a value-add 
> in creating more wrappers vs updating the existing callers.

Perhaps more reason not to modify the existing api.
