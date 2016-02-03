From: Ruediger Meier <sweet_f_a-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: scsi_debug, iosize optimal < minimum
Date: Wed, 3 Feb 2016 22:55:44 +0100
Message-ID: <201602032255.44508.sweet_f_a@gmx.de>
References: <201601291131.29201.sweet_f_a@gmx.de> <201601291718.21185.sweet_f_a@gmx.de> <yq1fuxcr5lk.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yq1fuxcr5lk.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
Content-Disposition: inline
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Monday 01 February 2016, Martin K. Petersen wrote:
> >>>>> "Ruediger" == Ruediger Meier <sweet_f_a-Mmb7MZpHnFY@public.gmane.org> writes:
>
> Ruediger> I've noticed a possible problem with scsi_debug devices
> where Ruediger> optimal_io_size < minimum_io_size.
>
> Ruediger> The problem seems reproducable with kernel 4.4.0 and also
> with Ruediger> stable version 4.1.15. For stable tree the last known
> working Ruediger> version is 4.1.13.
>
> http://git.kernel.org/cgit/linux/kernel/git/mkp/scsi.git/commit/?h=4.
>5/scsi-fixes&id=d0eb20a863ba7dc1d3f4b841639671f134560be2


Ah thanks!

But I'm still wondering a bit. Using kernel 4.5-rc2 (where 9c1d9c20 and 
d0eb20a8 is included) I get

$ getconf PAGESIZE
4096
$ modprobe scsi_debug
$  cat /sys/block/$devname/queue/{minimum_io_size,optimal_io_size}
512
524288

In past (kernel<=4.1) optimal_io_size io size was 32768. Is this really 
correct now?

cu,
Rudi
--
To unsubscribe from this list: send the line "unsubscribe util-linux" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
