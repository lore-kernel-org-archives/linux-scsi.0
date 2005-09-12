From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Fwd: Fw: [OOPS] 2.6.13-mm2 scsi, sata, ich5
Date: Mon, 12 Sep 2005 11:38:42 +0200
Message-ID: <6bffcb0e05091202382d2493c@mail.gmail.com>
References: <20050911232109.35720176.akpm@osdl.org>
	 <6bffcb0e05091202296a07f1ad@mail.gmail.com>
Reply-To: michal.k.k.piotrowski@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.194]:24340 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751264AbVILJiq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 05:38:46 -0400
Received: by wproxy.gmail.com with SMTP id i20so1720665wra
        for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2005 02:38:42 -0700 (PDT)
In-Reply-To: <6bffcb0e05091202296a07f1ad@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

---------- Forwarded message ----------
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Date: 12-Sep-2005 11:29
Subject: Re: Fw: [OOPS] 2.6.13-mm2 scsi, sata, ich5
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>


Hi,

On 12/09/05, Andrew Morton <akpm@osdl.org> wrote:
>
> This is a strange trace.   I assume one of the WARN_ON()s in
> kref_put() has triggered and there's stack stuff missing.   Or
> Maybe it's an oops under scsi_end_request(), but the oops trace doesn't
> use show_trace(), whcih that output is from.   But if it's not
> an oops, why is the Code: dump there.
>
> Head spins.   Michal, can you try to gather another trace?   Is there
> info missing from this one?
>
> (It's quite possibly a scsi thing rather than a sata thing, btw).
>

The oops always hapen about 3 seconds after system start booting. When
it hapen I can't see what is up, because shift+pageup doesn't work.
So, AFAIK the only way to catch that oops is serial console?

Regards,
Michal Piotrowski
