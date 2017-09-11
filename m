From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [man-pages PATCH] cciss.4, hpsa.4: mention cciss removal in Linux 4.13
Date: Mon, 11 Sep 2017 16:21:45 +0200
Message-ID: <CAKgNAkh=f5o+5KJ=5RY=O9pUe4zYJj86KMq8y=vshXvtwS7rMQ@mail.gmail.com>
References: <20170911025746.GA23341@asgard.redhat.com> <alpine.LRH.2.21.1709110958100.23935@math.ut.ee>
 <CACGkJdvGYZGSF0pSdh416BHWoaxY2KRkfx1th-ZZUX9u+MPzFg@mail.gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACGkJdvGYZGSF0pSdh416BHWoaxY2KRkfx1th-ZZUX9u+MPzFg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Meelis Roos <mroos-Y27EyoLml9s@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Don Brace <don.brace-dzo6w/eZyo2tG0bUXCXiUA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Eugene,

On 11 September 2017 at 14:36, Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Sep 11, 2017 at 8:58 AM, Meelis Roos <mroos-Y27EyoLml9s@public.gmane.org> wrote:
>> On Mon, 11 Sep 2017, Eugene Syromyatnikov wrote:
>>
>>> During the Linux 4.13 development cycle, cciss driver has been removed
>>> in flavor to hpsa driver that has been amended with some legacy board
>>> support.
>>
>> It's gone in 4.14 - 4.13 works the old way.
>
> Uhh, my bad, sorry: forgot to add --contain to git describe. I'll
> resend the patch.

Too late. I'll fix manually.

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
