From: adam radford <aradford@gmail.com>
Subject: Re: [Linux Megaraid SAS driver] bug report
Date: Fri, 2 Nov 2012 12:54:04 -0800
Message-ID: <CAHtARFFRCtgeabioYL-GHHoq7nHvs-VypOUF2JP1AeBTBnQDjg@mail.gmail.com>
References: <5093A936.5020709@credit-agricole.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40653 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab2KBUyG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Nov 2012 16:54:06 -0400
Received: by mail-qc0-f174.google.com with SMTP id o22so2684191qcr.19
        for <linux-scsi@vger.kernel.org>; Fri, 02 Nov 2012 13:54:04 -0700 (PDT)
In-Reply-To: <5093A936.5020709@credit-agricole.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?J=E9r=E9mie_GUILLAUME?= <jeremie.guillaume-prestataire@credit-agricole.net>
Cc: linux-scsi@vger.kernel.org

On Fri, Nov 2, 2012 at 3:06 AM, J=E9r=E9mie GUILLAUME
<jeremie.guillaume-prestataire@credit-agricole.net> wrote:
=2E..
> with 3.2.x kernels
> ------------------
>   - no problem occurs ; we have good data transfers , even in 64 Gb H=
igh
> Memory mode.

Jeremie,

The megaraid_sas driver changes from 3.2 kernel, version 6.12-rc1, to
3.3 kernel, version 6.14-rc1 are quite minimal and would not affect
any 32-bit 64 GB memory mode/PAE mode.

=46eel free to copy the following files from your 3.2 kernel source int=
o
your 3.3 kernel source:

drivers/scsi/megaraid/megaraid_sas_base.c megaraid_sas.h
megaraid_sas_fusion.c megaraid_sas_fusion.h megaraid_sas_fp.c

then rebuild your kernel and modules.  That should help you determine
if there was actually a megaraid_sas driver related performance
regression, since you will have the exact same driver code running for
both kernels.

-Adam
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
