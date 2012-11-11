From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] target: Update copyright ownership to 2012
Date: Sun, 11 Nov 2012 08:56:23 +0000
Message-ID: <1352624183.6524.26.camel@dabdike>
References: <1352502014-9782-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42610 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355Ab2KKI43 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Nov 2012 03:56:29 -0500
In-Reply-To: <1352502014-9782-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Fri, 2012-11-09 at 23:00 +0000, Nicholas A. Bellinger wrote:
> diff --git a/drivers/target/target_core_alua.c
> b/drivers/target/target_core_alua.c
> index 4c8eea2..035c606 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -3,8 +3,9 @@
>   *
>   * This file contains SPC-3 compliant asymmetric logical unit
> assigntment (ALUA)
>   *
> - * Copyright (c) 2009-2010 Rising Tide Systems
> - * Copyright (c) 2009-2010 Linux-iSCSI.org
> + * (c) Copyright 2009-2012 RisingTide Systems LLC.
> + *
> + * Licensed to the Linux Foundation under the General Public License
> (GPL) version 2.

I don't quite understand this last bit.  Firstly, I'm not aware of any
agreement with the Linux Foundation over this and secondly one of the
cardinal principles of GPL is the copyleft one that all downstreams get
equal rights, so you can't licence GPL code to anyone in particular
because you have to licence it to everyone.  Thirdly, I think it should
be the GNU General Public Licence.  In the context of the kernel, that's
probably taken as read, but if you're going to add it explicitly, might
as well be precise.

James


