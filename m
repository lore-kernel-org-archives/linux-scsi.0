From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 04/40] proc: introduce proc_create_seq{,_data}
Date: Mon, 30 Apr 2018 14:19:25 +0100
Message-ID: <26540.1525094365@warthog.procyon.org.uk>
References: <20180425154827.32251-5-hch@lst.de>
 <20180425154827.32251-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180425154827.32251-5-hch@lst.de>
Content-ID: <26539.1525094365.1@warthog.procyon.org.uk>
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
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, megaraidlinux.pdl@broadcom.com, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, dhowells@redhat.com, linux-ide@vger.kernel.org, netfilter-devel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, jfs-discussion@lists.sourceforge.net, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> +
> +struct proc_dir_entry *proc_create_seq_data(const char *name, umode_t mode,
> +		struct proc_dir_entry *parent, const struct seq_operations *ops,
> +		void *data)
> +{
> ...
> +EXPORT_SYMBOL(proc_create_seq_data);

Please add documentation comments to exported functions when you add them.

David
