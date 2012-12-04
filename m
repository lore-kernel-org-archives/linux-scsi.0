From: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: megaraid_sas: which patches are needed for 2.6.32.y?
Date: Mon, 3 Dec 2012 22:27:08 -0800
Message-ID: <20121204062708.GA7633@elie.Belkin>
References: <CAD2iGhWrruwSWtNo9pVH1Aufimq1W2G3VQKEHaWnmoXjnNk4cQ@mail.gmail.com>
 <20121203144310.GA1357@elie.Belkin>
 <CAD2iGhWegHsB+1P9unXn6sfveSQGFyahH9qKh4oHtXpxDSz1EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:44740 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab2LDG1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Dec 2012 01:27:18 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so1659301dak.19
        for <linux-scsi@vger.kernel.org>; Mon, 03 Dec 2012 22:27:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAD2iGhWegHsB+1P9unXn6sfveSQGFyahH9qKh4oHtXpxDSz1EA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?B?VG9yYmrDuHJu?= Thorsen <torbjorn@trollweb.no>
Cc: 666108@bugs.debian.org, Neela Syam Kolli <megaraidlinux@lsi.com>, adam radford <aradford@gmail.com>, linux-scsi@vger.kernel.org

tags 666108 - moreinfo
quit

Torbj=C3=B8rn Thorsen wrote:

> The kernel boots with no problems, the storage controller seems to be
> working nicely.
>
> root@xen14:~# dmesg | grep -i mega
> [    3.340638] megasas: 00.00.05.38-rc1 Wed. May. 11 17:00:00 PDT 201=
1
> [    3.340742] megasas: 0x1000:0x005b:0x1028:0x1f38: bus 3:slot 0:fun=
c 0

Yay, thanks much for checking.

Ben and Dann, what do you think?  Should we apply these patches[1]?

Regards,
Jonathan

[1] http://alioth.debian.org/~jrnieder-guest/temp/driver-test/megaraid-=
driver-backport.mbox
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
