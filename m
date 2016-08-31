From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v5 2/8] char: rpmb: add sysfs-class ABI documentation
Date: Wed, 31 Aug 2016 12:53:33 +0200
Message-ID: <20160831105333.GB10180@kroah.com>
References: <1468873673-21776-1-git-send-email-tomas.winkler@intel.com>
 <1468873673-21776-3-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mmc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1468873673-21776-3-git-send-email-tomas.winkler@intel.com>
Sender: linux-mmc-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 18, 2016 at 11:27:47PM +0300, Tomas Winkler wrote:
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
> V2: resend
> V3: add more verbose description
> V4: resend
> V5: adjust date and kernel version
> 
>  Documentation/ABI/testing/sysfs-class-rpmb | 20 ++++++++++++++++++++
>  MAINTAINERS                                |  1 +
>  2 files changed, 21 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-rpmb
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-rpmb b/Documentation/ABI/testing/sysfs-class-rpmb
> new file mode 100644
> index 000000000000..3ffcd2d1f683
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-rpmb
> @@ -0,0 +1,20 @@
> +What:		/sys/class/rpmb/
> +Date:		Aug 2016
> +KernelVersion:  4.8
> +Contact:	Tomas Winkler <tomas.winkler@intel.com>
> +Description:
> +		The rpmb/ class sub-directory belongs to RPMB device class.
> +
> +		Few storage technologies such is EMMC, UFS, and NVMe support
> +		Replay Protected Memory Block (RPMB) hardware partition with
> +		common protocol and frame layout.
> +		Such a partition provides authenticated and replay protected access,
> +		hence suitable as a secure storage.
> +
> +What:		/sys/class/rpmb/rpmbN/
> +Date:		Aug 2016
> +KernelVersion:	4.8
> +Contact:	Tomas Winkler <tomas.winkler@intel.com>
> +Description:
> +		The /sys/class/rpmb/rpmbN directory is created for
> +		each RPMB registered device

So you have no sysfs files?  If not, why have a sysfs class at all?

thanks,

greg k-h
