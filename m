From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [PATCH] megaraid:Make various functions static in megaraid_sas_fusion.c
Date: Fri, 18 Dec 2015 12:31:18 +0530
Message-ID: <90fa0319ef5f247c0f9021262d5a2a41@mail.gmail.com>
References: <1436200567-10779-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:35814 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbbLRHBV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2015 02:01:21 -0500
Received: by mail-lf0-f52.google.com with SMTP id l133so66433865lfd.2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Dec 2015 23:01:20 -0800 (PST)
In-Reply-To: <1436200567-10779-1-git-send-email-xerofoify@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>
Cc: Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, JBottomley@odin.com, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Nicholas Krause [mailto:xerofoify@gmail.com]
> Sent: Monday, July 06, 2015 10:06 PM
> To: kashyap.desai@avagotech.com
> Cc: sumit.saxena@avagotech.com; uday.lingala@avagotech.com;
> JBottomley@odin.com; megaraidlinux.pdl@avagotech.com; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] megaraid:Make various functions static in
> megaraid_sas_fusion.c
>
> This makes various functions that have no external callers outside of
their
> definition/declaration in the file megaraid_sas_fusion.c to be properly
> declared as static functions now.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

Nicholas -

You posted patch with subject line "megaraid:Make the function
megasas_alloc_cmd_fusion static" for similar code changes.
Let's have consolidated patch for this and Avago can post it with next
change set (to keep git  commit clean without any failure)

Just to be clear - You can send us patch and we can add with Submitted by
your name as signature. For now NACK.

` Kashyap
