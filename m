From: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>
Subject: RE: [PATCH 1/4] lib/hexdump.c: Allow 64 bytes per line
Date: Mon, 15 Apr 2019 10:56:39 +0000
Message-ID: <6912ef2d83d34c9299d5a5ad120c276f@AcuMS.aculab.com>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
 <20190410031720.11067-2-alastair@au1.ibm.com>
 <20190412134802.kprel2c2iqijd4ai@pathway.suse.cz>
 <092f01d4f186$8e9e7cd0$abdb7670$@d-silva.org>
 <20190415090232.3ualhrt5ssrb2ixq@pathway.suse.cz>
 <0dad01d4f376$113df2b0$33b9d810$@d-silva.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0dad01d4f376$113df2b0$33b9d810$@d-silva.org>
Content-Language: en-US
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Alastair D'Silva' <alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org>, 'Petr Mladek' <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: 'Jani Nikula' <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, 'Joonas Lahtinen' <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, 'Rodrigo Vivi' <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'David Airlie' <airlied-cv59FeDIM0c@public.gmane.org>, 'Daniel Vetter' <daniel-/w4YWyX8dFk@public.gmane.org>, 'Karsten Keil' <isdn-iHCpqvpFUx0uJkBD2foKsQ@public.gmane.org>, 'Jassi Brar' <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Tom Lendacky' <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, "'David S. Miller'" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, 'Jose Abreu' <Jose.Abreu-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, 'Kalle Valo' <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, 'Stanislaw Gruszka' <sgruszka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Benson Leung' <bleung-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, 'Enric Balletbo i Serra' <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, "'James E.J. Bottomley'" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "'Martin K. Petersen'" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Greg Kroah-Hartman' <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>'Alexander Viro' <v>
List-Id: linux-scsi@vger.kernel.org

From: Alastair D'Silva
> Sent: 15 April 2019 11:29
...
> I do, and I believe the choice of the output length should be in the hands
> of the caller.
> 
> On further thought, it would make more sense to remove the hardcoded list of
> sizes and just enforce a power of 2. The function shouldn't dictate what the
> caller can and can't do beyond the technical limits of it's implementation.

Why powers of two?
You may want the length to match sizeof (struct foo).
You might even want the address increment to be larger
that the number of lines dumped.

	David
