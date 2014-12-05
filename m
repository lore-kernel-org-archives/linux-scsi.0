From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 1/2] xhci: Add broken-streams quirk for Fresco Logic FL1000G
 xhci controllers
Date: Fri, 05 Dec 2014 14:15:05 +0300
Message-ID: <548193B9.5000904@cogentembedded.com>
References: <1417774289-15025-1-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:58795 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaLELPJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2014 06:15:09 -0500
Received: by mail-la0-f41.google.com with SMTP id hv19so462795lab.14
        for <linux-scsi@vger.kernel.org>; Fri, 05 Dec 2014 03:15:07 -0800 (PST)
In-Reply-To: <1417774289-15025-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Mathias Nyman <mathias.nyman@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?B?TWFyY2luIFphasSFY3prb3dza2k=?= <mszpak@wp.pl>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

Hello.

On 12/5/2014 1:11 PM, Hans de Goede wrote:

> Streams do not work reliabe on Fresco Logic FL1000G xhci controllers,

    s/reliabe/reliably/?

> trying to use them results in errors like this:

> 21:37:33 kernel: xhci_hcd 0000:04:00.0: ERROR Transfer event for disa=
bled endpoint or incorrect stream ring
> 21:37:33 kernel: xhci_hcd 0000:04:00.0: @00000000368b3570 9067b000 00=
000000 05000000 01078001
> 21:37:33 kernel: xhci_hcd 0000:04:00.0: ERROR Transfer event for disa=
bled endpoint or incorrect stream ring
> 21:37:33 kernel: xhci_hcd 0000:04:00.0: @00000000368b3580 9067b400 00=
000000 05000000 01038001

> As always I've ordered a pci-e addon card with a Fresco Logic control=
ler for
> myself to see if I can come up with a better fix then the big hammer,=
 in
> the mean time this will make uas devices work again (in usb-storage m=
ode)
> for FL1000G users.

> Reported-by: Marcin Zaj=C4=85czkowski <mszpak@wp.pl>
> Cc: stable@vger.kernel.org # 3.15
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

WBR, Sergei

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
