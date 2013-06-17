From: Baruch Even <baruch@ev-en.org>
Subject: Re: interrupt coalescing in LSI HBA controller
Date: Mon, 17 Jun 2013 23:53:02 +0300
Message-ID: <CAC9+anLXbPDN_Bg_CHOO0hB6_whoxy9XKv46sqihFLbvbduP=Q@mail.gmail.com>
References: <CAFLer81+p=-4NH5b6+VLSU6TcF-Vm_-FXKWhuUgzRgSOn3WCGA@mail.gmail.com>
 <CAC9+an+3P29pZ-hXAF31mgCeRT5iypLeWfi_Qf5cFTJrJ_cWHw@mail.gmail.com> <CAFLer81rKuzvKGqA-7kktMdRzsJ-08T8e9qZTNoQQ7w=kAJVdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:47512 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab3FQUxY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jun 2013 16:53:24 -0400
Received: by mail-ee0-f44.google.com with SMTP id c13so2098080eek.3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2013 13:53:22 -0700 (PDT)
In-Reply-To: <CAFLer81rKuzvKGqA-7kktMdRzsJ-08T8e9qZTNoQQ7w=kAJVdw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zheng Da <zhengda1936@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Jun 17, 2013 at 11:34 PM, Zheng Da <zhengda1936@gmail.com> wrote:
> Hello,
>
> I have tried lsiutil and it cannot recognize the LSI controllers. I
> have talked to the LSI tech support and they told me that lsiutil
> doesn't support this type of HBA controllers.
> I found lsiutil in some other place. I couldn't find it in on LSI's
> website. Do you know where I can download it from LSI's website?

I didn't try to find it at lsi, there are other places but if it
didn't work it wouldn't help much to find it in another place.

At work I wrote a utility based on the LSI documentation that works on
similar HBAs but I don't think I'd be able to release that. The
relevant headers are in the Linux kernel and you can try to ask LSI
support for the documentation directly, I obviously can't provide it.

Baruch
