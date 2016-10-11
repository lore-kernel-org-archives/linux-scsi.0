From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] hisi_sas add hip07 support
Date: Tue, 11 Oct 2016 16:34:10 -0400
Message-ID: <yq1lgxuocal.fsf@sermon.lab.mkp.net>
References: <1475579471-11308-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475579471-11308-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> (John
        Garry's message of "Tue, 4 Oct 2016 19:11:08 +0800")
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hare-IBi9RG/b67k@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "John" == John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> writes:

John> This patchset introduces support for hip07 SoC.  The hip07 SoC has
John> the same v2 hw as in hip06.

John> Support for different reference clock is required as some SAS
John> registers need be programmed differently, depending on the
John> refclock rate.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
