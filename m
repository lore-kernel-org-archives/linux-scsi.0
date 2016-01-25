From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 01/23] devicetree: bindings: hisi_sas: add v2 HW
 bindings
Date: Mon, 25 Jan 2016 13:31:14 -0600
Message-ID: <20160125193114.GA16531@rob-hp-laptop>
References: <1453742532-53092-1-git-send-email-john.garry@huawei.com>
 <1453742532-53092-2-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1453742532-53092-2-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: j00310691 <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: JBottomley-wo1vFcy6AUs@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 26, 2016 at 01:21:50AM +0800, j00310691 wrote:
> From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Add the dt bindings for HiSi SAS controller v2 HW.
> 
> The main difference in the controller from dt perspective
> is interrupts. The v2 controller does not have dedicated
> fatal and broadcast interrupts - they are multiplexed on
> the channel interrupt.
> 
> Each SAS v2 controller can issue upto 64 commands
> (or connection requests) on the system bus without waiting
> for a response - this is know as am-max-transmissions.
> In hip06, sas controller #1 has a limitation that it has to
> limit am-max-transmissions to 32 - this limitation is due
> to chip system bus design. It is not anticipated that any
> future chip incorporating v2 controller will have such a
> limitation.
> 
> Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  .../devicetree/bindings/scsi/hisilicon-sas.txt      | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)

Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
