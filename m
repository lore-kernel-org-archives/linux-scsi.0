From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
Date: Mon, 15 Apr 2019 10:20:56 +0000
Message-ID: <10c791893f034c26b4fee1a4659133e5@AcuMS.aculab.com>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
 <20190410031720.11067-4-alastair@au1.ibm.com>
 <20190412141211.lvnz6wb7mwkykmxf@pathway.suse.cz>
 <093301d4f187$da0756a0$8e1603e0$@d-silva.org>
 <20190415092424.qos7d54nbyr5hphu@pathway.suse.cz>
 <0da301d4f373$01d5bb80$05813280$@d-silva.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0da301d4f373$01d5bb80$05813280$@d-silva.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Alastair D'Silva' <alastair@d-silva.org>, 'Petr Mladek' <pmladek@suse.com>
Cc: 'Alastair D'Silva' <alastair@au1.ibm.com>, 'Jani Nikula' <jani.nikula@linux.intel.com>, 'Joonas Lahtinen' <joonas.lahtinen@linux.intel.com>, 'Rodrigo Vivi' <rodrigo.vivi@intel.com>, 'David Airlie' <airlied@linux.ie>, 'Daniel Vetter' <daniel@ffwll.ch>, 'Karsten Keil' <isdn@linux-pingi.de>, 'Jassi Brar' <jassisinghbrar@gmail.com>, 'Tom Lendacky' <thomas.lendacky@amd.com>, "'David S. Miller'" <davem@davemloft.net>, 'Jose Abreu' <Jose.Abreu@synopsys.com>, 'Kalle Valo' <kvalo@codeaurora.org>, 'Stanislaw Gruszka' <sgruszka@redhat.com>, 'Benson Leung' <bleung@chromium.org>, 'Enric Balletbo i Serra' <enric.balletbo@collabora.com>, "'James E.J. Bottomley'" <jejb@linux.ibm.com>, "'Martin K. Petersen'" <martin.petersen@oracle.com>, 'Greg Kroah-Hartman' <gregk>
List-Id: linux-scsi@vger.kernel.org

From: Alastair D'Silva
> Sent: 15 April 2019 11:07
...
> In the above example the author only wants the hex output, while in other
> situations, both hex & ASCII output is desirable. If you just want ASCII
> output, the caller should just use a printk or one of it's wrappers.

Hexdump will 'sanitise' the ASCII.

Although I think you'd want a 'no hex' flag to suppress the hex.

Probably more useful flags are ones to suppress the address column.
I've also used flags to enable (or disable) suppression of multiple
lines of zeros of constant bytes.
In that case you may want hexdump to return the flags for the
next call when a large buffer is being dumped in fragments.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
