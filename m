From: Christoph Hellwig <hch@sgi.com>
Subject: Re: [PATCH] scsi sysfs update (scsi_debug 3/3)
Date: Thu, 7 Nov 2002 18:30:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107183042.C15350@sgi.com>
References: <20021107073619.GA1390@beaverton.ibm.com> <20021107073943.GB1390@beaverton.ibm.com> <20021107074222.GC1390@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021107074222.GC1390@beaverton.ibm.com>; from andmike@us.ibm.com on Wed, Nov 06, 2002 at 11:42:22PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Nov 06, 2002 at 11:42:22PM -0800, Mike Anderson wrote:
> -#define DRIVERFS_SUPPORT 1	/* comment out whole line to disable */
> +#define SYSFS_SUPPORT 1 /* comment out whole line to disable */
> +#define SYSFS_PROBE 1  /* comment out whole line to disable */

Do we really want ifdefs for this?  And if yes why aren't they config
options?

