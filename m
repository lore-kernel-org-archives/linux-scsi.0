From: Jani Nikula <jani.nikula@linux.intel.com>
Subject: Re: [PATCH v3 4/7] lib/hexdump.c: Replace ascii bool in hex_dump_to_buffer with flags
Date: Mon, 17 Jun 2019 10:39:53 +0300
Message-ID: <87imt4vewm.fsf@intel.com>
References: <20190617020430.8708-1-alastair@au1.ibm.com> <20190617020430.8708-5-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190617020430.8708-5-alastair@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alastair D'Silva <alastair@au1.ibm.com>, alastair@d-silva.org
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Dan Carpenter <dan.carpenter@oracle.com>, Karsten Keil <isdn@linux-pingi.de>, Jassi Brar <jassisinghbrar@gmail.com>, Tom Lendacky <thomas.lendacky@amd.com>, "David S. Miller" <davem@davemloft.net>, Jose Abreu <Jose.Abreu@synopsys.com>, Kalle Valo <kvalo@codeaurora.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Benson Leung <bleung@chromium.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Petr
List-Id: linux-scsi@vger.kernel.org

On Mon, 17 Jun 2019, "Alastair D'Silva" <alastair@au1.ibm.com> wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
>
> In order to support additional features in hex_dump_to_buffer, replace
> the ascii bool parameter with flags.
>
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> ---
>  drivers/gpu/drm/i915/intel_engine_cs.c            |  2 +-
>  drivers/isdn/hardware/mISDN/mISDNisar.c           |  6 ++++--
>  drivers/mailbox/mailbox-test.c                    |  2 +-
>  drivers/net/ethernet/amd/xgbe/xgbe-drv.c          |  2 +-
>  drivers/net/ethernet/synopsys/dwc-xlgmac-common.c |  2 +-
>  drivers/net/wireless/ath/ath10k/debug.c           |  3 ++-
>  drivers/net/wireless/intel/iwlegacy/3945-mac.c    |  2 +-
>  drivers/platform/chrome/wilco_ec/debugfs.c        |  2 +-
>  drivers/scsi/scsi_logging.c                       |  8 +++-----
>  drivers/staging/fbtft/fbtft-core.c                |  2 +-
>  fs/seq_file.c                                     |  3 ++-
>  include/linux/printk.h                            |  8 ++++----
>  lib/hexdump.c                                     | 15 ++++++++-------
>  lib/test_hexdump.c                                |  5 +++--
>  14 files changed, 33 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_engine_cs.c b/drivers/gpu/drm/i915/intel_engine_cs.c
> index eea9bec04f1b..5df5fffdb848 100644
> --- a/drivers/gpu/drm/i915/intel_engine_cs.c
> +++ b/drivers/gpu/drm/i915/intel_engine_cs.c
> @@ -1340,7 +1340,7 @@ static void hexdump(struct drm_printer *m, const void *buf, size_t len)
>  		WARN_ON_ONCE(hex_dump_to_buffer(buf + pos, len - pos,
>  						rowsize, sizeof(u32),
>  						line, sizeof(line),
> -						false) >= sizeof(line));
> +						0) >= sizeof(line));
>  		drm_printf(m, "[%04zx] %s\n", pos, line);
>  
>  		prev = buf + pos;

On i915,

Acked-by: Jani Nikula <jani.nikula@intel.com>


-- 
Jani Nikula, Intel Open Source Graphics Center
