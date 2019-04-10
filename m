From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH 4/4] lib/hexdump.c: Allow multiple groups to be separated
 by lines '|'
Date: Wed, 10 Apr 2019 17:53:05 +0900
Message-ID: <20190410085305.GA4937@jagdpanzerIV>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
 <20190410031720.11067-5-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190410031720.11067-5-alastair@au1.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: Alastair D'Silva <alastair@au1.ibm.com>
Cc: alastair@d-silva.org, Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Karsten Keil <isdn@linux-pingi.de>, Jassi Brar <jassisinghbrar@gmail.com>, Tom Lendacky <thomas.lendacky@amd.com>, "David S. Miller" <davem@davemloft.net>, Jose Abreu <Jose.Abreu@synopsys.com>, Kalle Valo <kvalo@codeaurora.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Benson Leung <bleung@chromium.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.>
List-Id: linux-scsi@vger.kernel.org

On (04/10/19 13:17), Alastair D'Silva wrote:
> With the wider display format, it can become hard to identify how many
> bytes into the line you are looking at.
> 
> The patch adds new flags to hex_dump_to_buffer() and print_hex_dump() to
> print vertical lines to separate every N groups of bytes.
> 
> eg.
> buf:00000000: 454d414e 43415053|4e495f45 00584544  NAMESPAC|E_INDEX.
> buf:00000010: 00000000 00000002|00000000 00000000  ........|........

What if the output had |-s in it?  |||||||||

	-ss
