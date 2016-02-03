From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: scsi_debug, iosize optimal < minimum
Date: Wed, 03 Feb 2016 17:02:19 -0500
Message-ID: <yq1a8nhlafo.fsf@sermon.lab.mkp.net>
References: <201601291131.29201.sweet_f_a@gmx.de>
	<201601291718.21185.sweet_f_a@gmx.de>
	<yq1fuxcr5lk.fsf@sermon.lab.mkp.net>
	<201602032255.44508.sweet_f_a@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201602032255.44508.sweet_f_a-Mmb7MZpHnFY@public.gmane.org> (Ruediger Meier's message
	of "Wed, 3 Feb 2016 22:55:44 +0100")
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ruediger Meier <sweet_f_a-Mmb7MZpHnFY@public.gmane.org>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Ruediger" == Ruediger Meier <sweet_f_a-Mmb7MZpHnFY@public.gmane.org> writes:

Ruediger> In past (kernel<=4.1) optimal_io_size io size was 32768. Is
Ruediger> this really correct now?

We recently bumped the scsi_debug optimal I/O size to something akin to
what real-world storage reports.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe util-linux" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
