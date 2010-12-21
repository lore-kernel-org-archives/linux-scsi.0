From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 7/11]: megaraid_sas: Add MegaRAID 9265/9285 specific
 functions: megaraid_sas_fusion.c
Date: Tue, 21 Dec 2010 12:53:43 -0800
Message-ID: <AANLkTimxEvzUdjThuPVWNpMMw68=BFb=kMMs_7Rrr+QY@mail.gmail.com>
References: <AANLkTik1KwdG+73gWCqGj7sROdxWfBYfKqH4t=rcQkhi@mail.gmail.com>
	<20101221202810.GB15750@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43421 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab0LUUxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Dec 2010 15:53:44 -0500
Received: by qyk12 with SMTP id 12so4888116qyk.19
        for <linux-scsi@vger.kernel.org>; Tue, 21 Dec 2010 12:53:43 -0800 (PST)
In-Reply-To: <20101221202810.GB15750@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On Tue, Dec 21, 2010 at 12:28 PM, Christoph Hellwig <hch@infradead.org>=
 wrote:
> You should never allocate the scsi midlayer structures yourself,
> nevermind on stack. =A0It seems like you want a version of
> megasas_reset_fusion that just takes a scsi host and call it both fro=
m
> the work queue and the EH handler.
>

The final patch I sent moves the instantiation of these 2 variables
into megaraid_sas.h in struct megasas_instance.

You are right though, I will fix this and re-send the large 6-10 patch.

-Adam
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
