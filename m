From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 4/4] add xen pvscsi maintainer
Date: Fri, 27 Jun 2014 13:13:23 -0400
Message-ID: <20140627171323.GB30451@laptop.dumpdata.com>
References: <1403879676-25431-1-git-send-email-jgross@suse.com>
	<1403879676-25431-5-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
Content-Disposition: inline
In-Reply-To: <1403879676-25431-5-git-send-email-jgross@suse.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: jgross@suse.com
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 27, 2014 at 04:34:36PM +0200, jgross@suse.com wrote:
> From: Juergen Gross <jgross@suse.com>
> 
> Add myself as maintainer for the Xen pvSCSI stuff.

Woot!

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ebc8128..78c60e6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10008,6 +10008,13 @@ S:	Supported
>  F:	arch/x86/pci/*xen*
>  F:	drivers/pci/*xen*
>  
> +XEN PVSCSI DRIVERS
> +M:	Juergen Gross <jgross@suse.com>
> +L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
> +S:	Supported
> +F:	drivers/scsi/xen*
> +F:	include/xen/interface/io/vscsiif.h
> +
>  XEN SWIOTLB SUBSYSTEM
>  M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>  L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
> -- 
> 1.8.4.5
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
