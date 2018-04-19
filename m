From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 03/39] proc: introduce proc_create_seq_private
Date: Thu, 19 Apr 2018 21:50:27 +0300
Message-ID: <20180419185027.GC2066@avx2>
References: <20180419124140.9309-1-hch@lst.de>
 <20180419124140.9309-4-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20180419124140.9309-4-hch@lst.de>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, Corey Minyard <minyard@acm.org>, linux-ide@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, megaraidlinux.pdl@broadcom.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 19, 2018 at 02:41:04PM +0200, Christoph Hellwig wrote:
> Variant of proc_create_data that directly take a struct seq_operations

> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -45,6 +45,7 @@ struct proc_dir_entry {
>  	const struct inode_operations *proc_iops;
>  	const struct file_operations *proc_fops;
>  	const struct seq_operations *seq_ops;
> +	size_t state_size;

"unsigned int" please.

Where have you seen 4GB priv states?
