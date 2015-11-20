From: Ruediger Meier <sweet_f_a-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH] scsi_debug: fix prevent_allow+verify regressions
Date: Fri, 20 Nov 2015 12:00:37 +0100
Message-ID: <201511201200.38623.sweet_f_a@gmx.de>
References: <5522A0C5.9030804@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5522A0C5.9030804-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
Content-Disposition: inline
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org
Cc: SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, jbottomley-wo1vFcy6AUs@public.gmane.org, util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi,

what happened to this patch? It's still not merged into the kernel. 
That's a pity.

cu,
Rudi

On Monday 06 April 2015, Douglas Gilbert wrote:
> Ruediger Meier observed a regression with the PREVENT ALLOW
> MEDIUM REMOVAL command in lk 3.19:
>    http://www.spinics.net/lists/util-linux-ng/msg11448.html
>
> Inspection indicated the same regression with VERIFY(10).
>
> The patch is against lk 3.19.3 and also works with lk 4.0.0-rc6.
> With this patch both commands are accepted and do nothing.
> VERIFY(10) could be implemented since it shares logic with
> COMPARE AND WRITE which is implemented; however that would
> be an enhancement.
>
> ChangeLog:
>    - fix the lk 3.19 regression so that the PREVENT ALLOW
>      MEDIUM REMOVAL command is supported once again
>    - same fix for VERIFY(10)
>
> Signed-off-by: Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe util-linux" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
