From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/71] atari_scsi: Fix SCSI host ID setting
Date: Thu, 19 Nov 2015 08:37:22 +0100
Message-ID: <564D7C32.4040207@suse.de>
References: <20151118083455.331768508@telegraphics.com.au>
 <20151118083455.601781406@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151118083455.601781406@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/18/2015 09:34 AM, Finn Thain wrote:
> The NVRAM location of this byte is 16, as documented in
> http://toshyp.atari.org/en/004009.html
>
> This was confirmed by Michael Schmitz, by setting the SCSI host ID
> under EmuTOS and then checking the value in /proc/driver/nvram and
> /dev/nvram under Linux.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
