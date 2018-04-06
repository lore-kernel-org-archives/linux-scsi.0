From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 01/10] staging: fnic2 add initialization
Date: Fri, 6 Apr 2018 07:07:52 +0200
Message-ID: <20180406050752.GC27591@kroah.com>
References: <20180405211519.GA12584@osmithde-lnx.cisco.com>
 <20180405211644.GB12584@osmithde-lnx.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180405211644.GB12584@osmithde-lnx.cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oliver Smith-Denny <osmithde@cisco.com>
Cc: Sesidhar Baddela <sebaddel@cisco.com>, Gian Carlo Boffa <gcboffa@cisco.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 05, 2018 at 02:16:45PM -0700, Oliver Smith-Denny wrote:
> These files contain module load and unload, global driver context,
> PCI registration, PCI probe and remove, and definitions of
> the fnic2 global context.
> 
> Signed-off-by: Oliver Smith-Denny <osmithde@cisco.com>
> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
> Signed-off-by: Anil Chintalapati <achintal@cisco.com>
> Signed-off-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Signed-off-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Co-Developed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Co-Developed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Co-Developed-by: Oliver Smith-Denny <osmithde@cisco.com>
> ---
>  drivers/staging/fnic2/src/fnic2.h      | 256 ++++++++++++
>  drivers/staging/fnic2/src/fnic2_main.c | 711 +++++++++++++++++++++++++++++++++
>  2 files changed, 967 insertions(+)
>  create mode 100644 drivers/staging/fnic2/src/fnic2.h
>  create mode 100644 drivers/staging/fnic2/src/fnic2_main.c

Why is this a drivers/staging/ driver at all?  What is keeping you from
getting this merged into the "proper" place in the kernel?

If you have a staging driver, you have to have a TODO file in the
directory listing what is keeping this in the staging section.

Also, one tiny thing to fix up:

> --- /dev/null
> +++ b/drivers/staging/fnic2/src/fnic2.h
> @@ -0,0 +1,256 @@
> +/*
> + * SPDX-License-Identifier: GPL-2.0

Please read the documentation on how to properly use SPDX tags on kernel
files.  This needs to be the first line of the file.

thanks,

greg k-h
