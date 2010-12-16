From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 7/11]: megaraid_sas: Add MegaRAID 9265/9285 specific
 functions: megaraid_sas_fusion.c
Date: Thu, 16 Dec 2010 08:58:11 -0800
Message-ID: <AANLkTikEB02WAiHTYe=FLm9EKhjTdaLLd97NQvWg2Y9t@mail.gmail.com>
References: <AANLkTik1KwdG+73gWCqGj7sROdxWfBYfKqH4t=rcQkhi@mail.gmail.com>
	<4D0A1AD0.1040703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34682 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab0LPQ6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Dec 2010 11:58:12 -0500
Received: by qyj19 with SMTP id 19so553915qyj.19
        for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2010 08:58:12 -0800 (PST)
In-Reply-To: <4D0A1AD0.1040703@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On Thu, Dec 16, 2010 at 5:57 AM, Tomas Henzl <thenzl@redhat.com> wrote:
> Hi Adam, Bo,
>
> The function megasas_fusion_ocr_wq seems to be used already in patch =
6/11
> and declared in 7/11 - this breaks bisectability.
>
> Further my compiler complains about a large frame size.
> Probably the 'struct scsi_device dev' is too large to be on stack.
> make checkstack
> ...
> 0x000090f4 megasas_fusion_ocr_wq [megaraid_sas]: =A0 =A0 =A0 =A01696
>

Tomas,

Thanks, we will fix this and repost patches 6 thru 10.

-Adam
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
