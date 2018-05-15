From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: simplify procfs code for seq_file instances V2
Date: Tue, 15 May 2018 16:03:26 +0200
Message-ID: <20180515140326.GC31296@lst.de>
References: <20180425154827.32251-1-hch@lst.de> <20180506171948.GA769@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180506171948.GA769@avx2>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rtc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Alexandre Belloni <alexandre.belloni-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jiri Slaby <jslaby-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, megaraidlinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sun, May 06, 2018 at 08:19:49PM +0300, Alexey Dobriyan wrote:
> On Wed, Apr 25, 2018 at 05:47:47PM +0200, Christoph Hellwig wrote:
> > Changes since V1:
> >  - open code proc_create_data to avoid setting not fully initialized
> >    entries live
> >  - use unsigned int for state_size
> 
> Need this to maintain sizeof(struct proc_dir_entry):

I'll fold your changes into the relevant patches.

> Otherwise ACK fs/proc/ part.

I'll take this as a formal ACK-ed by for all patches touching
procfs.  If I was wrong please scream.
