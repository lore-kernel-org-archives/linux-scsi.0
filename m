From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: RE: [patch 5/7] scsi: le*_add_cpu conversion
Date: Wed, 5 Mar 2008 06:01:29 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F4831D6B01@ADPE2K703.adaptec.com>
References: <200803042324.m24NOP97003093@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:43180 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbYCEOBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 09:01:31 -0500
In-Reply-To: <200803042324.m24NOP97003093@imap1.linux-foundation.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "marcin.slusarz@gmail.com" <marcin.slusarz@gmail.com>

I ACKed this patch for aacraid and ips in the past, I continue to support it.

Sincerely -- Mark Salyzyn

> -----Original Message-----
. . .
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
>
> replace all:
> little_endian_variable =
> cpu_to_leX(leX_to_cpu(little_endian_variable) +
>                                         expression_in_cpu_byteorder);
> with:
>         leX_add_cpu(&little_endian_variable,
> expression_in_cpu_byteorder);
> generated with semantic patch
>
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: James.Bottomley@HansenPartnership.com
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
. . .
