From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] scsi: sg: Prevent potential double frees in sg driver
Date: Thu, 3 Aug 2017 12:23:54 -0700
Message-ID: <20170803192354.GA1598@kroah.com>
References: <20170803190248.51537-1-ndesaulniers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170803190248.51537-1-ndesaulniers@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: hare@suse.de, jthumshirn@suse.de, hch@lst.de, salyzyn@google.com, Robb Glasser <rglasser@google.com>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 03, 2017 at 12:02:47PM -0700, Nick Desaulniers wrote:
> From: Robb Glasser <rglasser@google.com>
> 
> sg_ioctl could be spammed by requests, leading to a double free in
> __free_pages. This protects the entry points of sg_ioctl where the
> memory could be corrupted by a double call to __free_pages if multiple
> requests are happening concurrently.
> 
> Signed-off-by: Robb Glasser <rglasser@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  drivers/scsi/sg.c | 2 ++
>  1 file changed, 2 insertions(+)

Why no one on the to: line?

And do you want this in the stable kernel trees?  If so, please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

thanks,

greg k-h
