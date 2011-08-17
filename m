From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: Document generic scsi device attributes
Date: Wed, 17 Aug 2011 12:45:06 -0700
Message-ID: <1313610306.6345.4.camel@mulgrave>
References: <20110817182055.8848.75862.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110817182055.8848.75862.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-08-17 at 13:20 -0500, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  Documentation/ABI/testing/sysfs-class-scsi_devices |  123 ++++++++++++++++++++
>  1 files changed, 123 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-scsi_devices
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-scsi_devices b/Documentation/ABI/testing/sysfs-class-scsi_devices
> new file mode 100644
> index 0000000..ad2d36b
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-scsi_devices
> @@ -0,0 +1,123 @@
> +What:           /sys/class/scsi_device/..../device/device_blocked
> +Date:           December, 2002
> +KernelVersion:  Unknown
> +Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>

Hmm, so I get fingered for every screw up in our sysfs ABI? nice wide
receiver buck pass move.

James
