From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
Date: Mon, 10 Jan 2011 15:46:41 -0800
Message-ID: <20110110234640.GC4879@mail.oracle.com>
References: <1294688708-24986-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1294688708-24986-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-next-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Joel Becker <joel.becker@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 10, 2011 at 11:45:08AM -0800, Nicholas A. Bellinger wrote:
> This patch changes configfs to select SYSFS to fix the following:
> 
> warning: (TARGET_CORE && GFS2_FS) selects CONFIGFS_FS which has unmet direct dependencies (SYSFS)

	If others are selecting CONFIGFS_FS, I'm thinking that this must
go in.  So

Acked-by: Joel Becker <jlbec@evilplan.org>

> 
> This patch also fixes whitespace breakage in the 'help' section.
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  fs/configfs/Kconfig |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/configfs/Kconfig b/fs/configfs/Kconfig
> index 13587cc..0e4bd23 100644
> --- a/fs/configfs/Kconfig
> +++ b/fs/configfs/Kconfig
> @@ -1,11 +1,11 @@
>  config CONFIGFS_FS
>  	tristate "Userspace-driven configuration filesystem"
> -	depends on SYSFS
> +	select SYSFS
>  	help
> -	  configfs is a ram-based filesystem that provides the converse
> -	  of sysfs's functionality. Where sysfs is a filesystem-based
> -	  view of kernel objects, configfs is a filesystem-based manager
> -	  of kernel objects, or config_items.
> +	configfs is a RAM-based filesystem that provides the converse
> +	of sysfs's functionality. Where sysfs is a filesystem-based
> +	view of kernel objects, configfs is a filesystem-based manager
> +	of kernel objects, or config_items.
>  
> -	  Both sysfs and configfs can and should exist together on the
> -	  same system. One is not a replacement for the other.
> +	Both sysfs and configfs can and should exist together on the
> +	same system. One is not a replacement for the other.
> -- 
> 1.7.3.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

Life's Little Instruction Book #451

	"Don't be afraid to say, 'I'm sorry.'"

			http://www.jlbec.org/
			jlbec@evilplan.org
