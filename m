From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/6] Drivers: hv: Add the GUID fot synthetic fiber
 channel device
Date: Thu, 16 May 2013 00:01:45 -0400
Message-ID: <20130516040145.GC16728@kroah.com>
References: <1368655320-27599-1-git-send-email-kys@microsoft.com>
 <1368655354-27651-1-git-send-email-kys@microsoft.com>
 <1368655354-27651-2-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1368655354-27651-2-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Wed, May 15, 2013 at 03:02:30PM -0700, K. Y. Srinivasan wrote:
> In preparation for supporting synthetic Fiber Channel device, add the GUID for
> this service.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  include/linux/hyperv.h |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
