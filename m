From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [PATCH] megaraid:Make the function megasas_alloc_cmd_fusion static
Date: Fri, 18 Dec 2015 12:27:47 +0530
Message-ID: <5687bd3c8aaf87c78537bd0b433236b5@mail.gmail.com>
References: <1450325373-20877-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35330 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbbLRG5u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2015 01:57:50 -0500
Received: by mail-lf0-f45.google.com with SMTP id l133so66389958lfd.2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Dec 2015 22:57:49 -0800 (PST)
In-Reply-To: <1450325373-20877-1-git-send-email-xerofoify@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>
Cc: Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, JBottomley@odin.com, martin.petersen@oracle.com, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> -int
> +static int
>  megasas_alloc_cmds_fusion(struct megasas_instance *instance)  {
>  	int i, j, count;

Good catch.  Let's not include patch to avoid further confusion on series
of acked patch which are not making significant functional difference.
NACK as not making any functional difference. We can make many more such
changes in one shot and let's address those later as we have few patches
ready to send in few days.


> --
> 2.5.0
