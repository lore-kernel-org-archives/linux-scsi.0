From: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH 02/15] drm: make device_type const
Date: Fri, 25 Aug 2017 15:36:24 +0200
Message-ID: <20170825133623.3jbkpvq5k62rabf5@phenom.ffwll.local>
References: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
 <1503130946-2854-3-git-send-email-bhumirks@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1503130946-2854-3-git-send-email-bhumirks@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: heikki.krogerus@linux.intel.com, airlied@linux.ie, linux-pci@vger.kernel.org, heiko.carstens@de.ibm.com, dri-devel@lists.freedesktop.org, bjorn.andersson@linaro.org, linux-tegra@vger.kernel.org, thierry.reding@gmail.com, linux-mtd@lists.infradead.org, daniel.vetter@intel.com, kishon@ti.com, freude@de.ibm.com, boris.brezillon@free-electrons.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, richard@nod.at, jonathanh@nvidia.com, marek.vasut@gmail.com, fcoe-devel@open-fcoe.org, dvhart@infradead.org, tomas.winkler@intel.com, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, ohad@wizery.com, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, linux-remoteproc@vger.kernel.org, johan@kernel.org, jani.nikula@linux.intel.com, julia.lawall@lip6.fr, seanpaul@chromium.org, bhelgaas@google.com, mchehab@kernel.org, linux-edac@vger.kernel.org, cleech@redhat.com, jth@
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 19, 2017 at 01:52:13PM +0530, Bhumika Goyal wrote:
> Make these const as they are only stored in the type field of a device
> structure, which is const.
> Done using Coccinelle.

I can't apply this, it's missing your s-o-b line. You can just replay with
that.

Thanks, Daniel

> ---
>  drivers/gpu/drm/drm_sysfs.c      | 2 +-
>  drivers/gpu/drm/ttm/ttm_module.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
> index 1c5b5ce..84e4ebe 100644
> --- a/drivers/gpu/drm/drm_sysfs.c
> +++ b/drivers/gpu/drm/drm_sysfs.c
> @@ -39,7 +39,7 @@
>   * drm_connector_unregister().
>   */
>  
> -static struct device_type drm_sysfs_device_minor = {
> +static const struct device_type drm_sysfs_device_minor = {
>  	.name = "drm_minor"
>  };
>  
> diff --git a/drivers/gpu/drm/ttm/ttm_module.c b/drivers/gpu/drm/ttm/ttm_module.c
> index 66fc639..e6604e0 100644
> --- a/drivers/gpu/drm/ttm/ttm_module.c
> +++ b/drivers/gpu/drm/ttm/ttm_module.c
> @@ -37,7 +37,7 @@
>  static DECLARE_WAIT_QUEUE_HEAD(exit_q);
>  static atomic_t device_released;
>  
> -static struct device_type ttm_drm_class_type = {
> +static const struct device_type ttm_drm_class_type = {
>  	.name = "ttm",
>  	/**
>  	 * Add pm ops here.
> -- 
> 1.9.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
