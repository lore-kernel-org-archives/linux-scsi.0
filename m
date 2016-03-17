From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 2/6] added UFS 2.0 capabilities
Date: Thu, 17 Mar 2016 06:52:41 -0500
Message-ID: <20160317115241.GB18144@rob-hp-laptop>
References: <cover.1457111366.git.jpinto@synopsys.com>
 <fcc0aa6a294a02dcab590d56f7f43bcb2f9f18db.1457111366.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fcc0aa6a294a02dcab590d56f7f43bcb2f9f18db.1457111366.git.jpinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Cc: vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, CARLOS.PALMINHA-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 04, 2016 at 05:22:15PM +0000, Joao Pinto wrote:
> Adding UFS 2.0 support to the UFS core driver.
> 
> Signed-off-by: Joao Pinto <jpinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
> ---
> Changes v8->v10:
> - Nothing changed (just to keep up with patch set version).
> Changes v7->v8:
> - Added "jedec, ufs-2.0" to the ufschd-platform compatibility strings
> Changes v0->v7:
> - Nothing changed (just to keep up with patch set version).
> 
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  4 +--
>  drivers/scsi/ufs/ufshcd.c                          | 29 +++++++++++++++++++---
>  drivers/scsi/ufs/ufshci.h                          |  1 +
>  3 files changed, 28 insertions(+), 6 deletions(-)

Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
