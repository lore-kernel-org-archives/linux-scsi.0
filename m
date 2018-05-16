From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 41/42] tty: replace ->proc_fops with ->proc_show
Date: Wed, 16 May 2018 11:58:02 +0200
Message-ID: <20180516095802.GA16090@kroah.com>
References: <20180516094346.20506-1-hch@lst.de>
 <20180516094346.20506-42-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20180516094346.20506-42-hch@lst.de>
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
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, linux-ide@vger.kernel.org, netfilter-devel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, jfs-discussion@lists.sourceforge.net, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

On Wed, May 16, 2018 at 11:43:45AM +0200, Christoph Hellwig wrote:
> Just set up the show callback in the tty_operations, and use
> proc_create_single_data to create the file without additional
> boilerplace code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
