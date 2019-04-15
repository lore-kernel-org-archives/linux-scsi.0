From: "Alastair D'Silva" <alastair@d-silva.org>
Subject: RE: [PATCH 1/4] lib/hexdump.c: Allow 64 bytes per line
Date: Mon, 15 Apr 2019 20:59:36 +1000
Message-ID: <0dc901d4f37a$52733a70$f759af50$@d-silva.org>
References: <20190410031720.11067-1-alastair@au1.ibm.com> <20190410031720.11067-2-alastair@au1.ibm.com> <20190412134802.kprel2c2iqijd4ai@pathway.suse.cz> <092f01d4f186$8e9e7cd0$abdb7670$@d-silva.org> <20190415090232.3ualhrt5ssrb2ixq@pathway.suse.cz> <0dad01d4f376$113df2b0$33b9d810$@d-silva.org> <6912ef2d83d34c9299d5a5ad120c276f@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6912ef2d83d34c9299d5a5ad120c276f@AcuMS.aculab.com>
Content-Language: en-au
Sender: linux-kernel-owner@vger.kernel.org
To: 'David Laight' <David.Laight@ACULAB.COM>, 'Petr Mladek' <pmladek@suse.com>
Cc: 'Jani Nikula' <jani.nikula@linux.intel.com>, 'Joonas Lahtinen' <joonas.lahtinen@linux.intel.com>, 'Rodrigo Vivi' <rodrigo.vivi@intel.com>, 'David Airlie' <airlied@linux.ie>, 'Daniel Vetter' <daniel@ffwll.ch>, 'Karsten Keil' <isdn@linux-pingi.de>, 'Jassi Brar' <jassisinghbrar@gmail.com>, 'Tom Lendacky' <thomas.lendacky@amd.com>, "'David S. Miller'" <davem@davemloft.net>, 'Jose Abreu' <Jose.Abreu@synopsys.com>, 'Kalle Valo' <kvalo@codeaurora.org>, 'Stanislaw Gruszka' <sgruszka@redhat.com>, 'Benson Leung' <bleung@chromium.org>, 'Enric Balletbo i Serra' <enric.balletbo@collabora.com>, "'James E.J. Bottomley'" <jejb@linux.ibm.com>, "'Martin K. Petersen'" <martin.petersen@oracle.com>, 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

> From: Alastair D'Silva
> > Sent: 15 April 2019 11:29
> ...
> > I do, and I believe the choice of the output length should be in the
> > hands of the caller.
> >
> > On further thought, it would make more sense to remove the hardcoded
> > list of sizes and just enforce a power of 2. The function shouldn't
> > dictate what the caller can and can't do beyond the technical limits =
of it's
> implementation.
>=20
> Why powers of two?
> You may want the length to match sizeof (struct foo).
> You might even want the address increment to be larger that the number =
of
> lines dumped.

Good point, the base requirement is that it should be a multiple of =
groupsize.

--=20
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva     msn: alastair@d-silva.org
blog: http://alastair.d-silva.org    Twitter: @EvilDeece
