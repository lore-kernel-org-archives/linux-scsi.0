From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 4/7] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
Date: Wed, 8 May 2019 11:14:19 +0200
Message-ID: <20190508091419.GA1615@kroah.com>
References: <20190508070148.23130-1-alastair@au1.ibm.com>
 <20190508070148.23130-5-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190508070148.23130-5-alastair@au1.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: Alastair D'Silva <alastair@au1.ibm.com>
Cc: alastair@d-silva.org, linux-fbdev@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>, Petr Mladek <pmladek@suse.com>, David Airlie <airlied@linux.ie>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>, ath10k@lists.infradead.org, intel-gfx@lists.freedesktop.org, Dan Carpenter <dan.carpenter@oracle.com>, Jose Abreu <Jose.Abreu@synopsys.com>, Tom Lendacky <thomas.lendacky@amd.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Jani Nikula <jani.nikula@linux.intel.com>, linux-fsdevel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Benson Leung <bleung@chromium.org>, Kalle
List-Id: linux-scsi@vger.kernel.org

On Wed, May 08, 2019 at 05:01:44PM +1000, Alastair D'Silva wrote:
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

For staging stuff:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
