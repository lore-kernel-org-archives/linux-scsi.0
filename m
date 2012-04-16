From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Commit a692b0e broke my mvsas card
Date: Mon, 16 Apr 2012 16:12:59 -0700
Message-ID: <CABE8wwvbSsc02U_m+20-DQgsZ2gQCi_A6susCrmfyx_scQkccw@mail.gmail.com>
References: <20120416224250.GA1983@bill-the-cat>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga12.intel.com ([143.182.124.36]:42273 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754673Ab2DPXND convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Apr 2012 19:13:03 -0400
Received: by bkcjm19 with SMTP id jm19so4100586bkc.25
        for <linux-scsi@vger.kernel.org>; Mon, 16 Apr 2012 16:13:00 -0700 (PDT)
In-Reply-To: <20120416224250.GA1983@bill-the-cat>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Rini <trini@ti.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <JBottomley@parallels.com>, Xiangliang Yu <yuxiangl@marvell.com>

On Mon, Apr 16, 2012 at 3:42 PM, Tom Rini <trini@ti.com> wrote:
> Hey all,
>
> I have an OCZ RevoDrive3 X2 (which the mvsas driver works for). =A0I'=
ve
> been running mainline since support for my card was added and I just
> went to test 3.3-rc4. =A0Unpatched I get some sort of recursive fault=
 that

I assume this was supposed to be 3.4-rc3?

> locks up the system. =A0When I revert a692b0e (which I found with a g=
it
> bisect) things are working as expected again. =A0What info do you nee=
d
> from me to work out the right solution here? =A0Thanks!

Can you post the kernel log of the fault (starting at the first sign
of trouble)?

I suspect it's one of the known regression fixes [1], but would like
to double check.

--
Dan

[1]: http://marc.info/?l=3Dlinux-scsi&m=3D133435937115299&w=3D2
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
