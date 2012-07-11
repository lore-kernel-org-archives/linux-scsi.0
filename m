From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH RESEND 3/3] drivers/scsi/ufs: fix incorrect return value
 about SUCCESS and FAILED
Date: Wed, 11 Jul 2012 13:12:02 +0900
Message-ID: <CAKYAXd8OOstW+1u=ki_+ZLhYAKQiaEGO5mR4Nd4FqevNjs_OkA@mail.gmail.com>
References: <1341931340.3021.70.camel@dabdike.int.hansenpartnership.com>
	<1341933114-10017-1-git-send-email-svenkatr@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62978 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab2GKEMD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jul 2012 00:12:03 -0400
Received: by wibhr14 with SMTP id hr14so669903wib.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jul 2012 21:12:02 -0700 (PDT)
In-Reply-To: <1341933114-10017-1-git-send-email-svenkatr@ti.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Venkatraman S <svenkatr@ti.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org

Thanks Venkat !

2012/7/11, Venkatraman S <svenkatr@ti.com>:
> From: Namjae Jeon <linkinjeon@gmail.com>
>
> Currently the UFS host driver has returned incorrect values for SUCCESS
> and FAILED.  Fix it to return the correct value to the upper layer.
>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Acked-by: Santosh Y <santoshsy@gmail.com>
> Signed-off-by: Venkatraman S <svenkatr@ti.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
