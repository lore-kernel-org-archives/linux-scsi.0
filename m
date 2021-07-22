Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31851C63798
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 17:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E05761380
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 17:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhGVRMN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 13:12:13 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:41892 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhGVRMN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 13:12:13 -0400
Received: by mail-pj1-f51.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so421853pjd.0;
        Thu, 22 Jul 2021 10:52:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K3HPpXj94khoLMhRAvGMvJwHM2ZP5MhdxDP3Axq5lwE=;
        b=rewTQXYLVFMKNhrxrLK3QDFD2WWyZSz1+dcQid8CI3YT5NkIMNi/eqIKQlPlMmy9JI
         wcO3iThzTDqUXwj0TFV3N70kmGoir7fjbeIJIE0XuZ7cGhxlb+MMxETDcNq2lj0NO16r
         Ys2EhzZHeNiM5EZU9aWTnRX+zG2i1EfZdOSmd15Z+lWHn5IRW+xLqwsQZulXiZOWFlnw
         psqVzf0sOizKroCZ/Vm9VnL1slcSwHqYa6N8+Cae/8hDz3J54xVx5XO1uHvY1GelfWRo
         WWvpM+BFbIRjtVszOfrDF+f5v/KWxt+sU60UjLy5BAtSqDxQGx15UC+sitJUfCtp1Bwo
         k9Dg==
X-Gm-Message-State: AOAM533ynzmvD9gS9BazMBIlVGcuMW6uFll5JLQq3kKCSQsXF+CrHSTk
        /vULMfPZnJs6G8Z0T5GTqb/uRmYc4w6sNWo2WRM=
X-Google-Smtp-Source: ABdhPJyG/YVtuYv4FIqWZptHg2xRcT6JOXt1Yd0Yc40WgHNEIGR+DgWkwez5EkBtcXURP6JqsTJsPA==
X-Received: by 2002:a17:902:b116:b029:12b:84fa:8c70 with SMTP id q22-20020a170902b116b029012b84fa8c70mr939589plr.40.1626976366371;
        Thu, 22 Jul 2021 10:52:46 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:6539:4b6a:66a5:486f])
        by smtp.gmail.com with ESMTPSA id bj15sm26433485pjb.6.2021.07.22.10.52.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 10:52:45 -0700 (PDT)
Subject: Re: [PATCH 20/24] scsi: remove a very misleading comment
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210712054816.4147559-1-hch@lst.de>
 <20210712054816.4147559-21-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <47a8e460-125e-6219-5ae6-d3c601e72350@acm.org>
Date:   Thu, 22 Jul 2021 10:52:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712054816.4147559-21-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/11/21 10:48 PM, Christoph Hellwig wrote:
> Remove the comment above ioctl_internal_command, which doesn't
> document this function at all.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_ioctl.c | 23 -----------------------
>   1 file changed, 23 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
> index a70ddc1eb313..3d4311a78383 100644
> --- a/drivers/scsi/scsi_ioctl.c
> +++ b/drivers/scsi/scsi_ioctl.c
> @@ -64,29 +64,6 @@ static int ioctl_probe(struct Scsi_Host *host, void __user *buffer)
>   	return 1;
>   }
>   
> -/*
> -
> - * The SCSI_IOCTL_SEND_COMMAND ioctl sends a command out to the SCSI host.
> - * The IOCTL_NORMAL_TIMEOUT and NORMAL_RETRIES  variables are used.
> - *
> - * dev is the SCSI device struct ptr, *(int *) arg is the length of the
> - * input data, if any, not including the command string & counts,
> - * *((int *)arg + 1) is the output buffer size in bytes.
> - *
> - * *(char *) ((int *) arg)[2] the actual command byte.
> - *
> - * Note that if more than MAX_BUF bytes are requested to be transferred,
> - * the ioctl will fail with error EINVAL.
> - *
> - * This size *does not* include the initial lengths that were passed.
> - *
> - * The SCSI command is read from the memory location immediately after the
> - * length words, and the input data is right after the command.  The SCSI
> - * routines know the command size based on the opcode decode.
> - *
> - * The output area is then filled in starting from the command byte.
> - */
> -
>   static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
>   				  int timeout, int retries)
>   {

How about adding a comment that explains what this function does? How 
about declaring 'cmd' const and adding a comment that it is a pointer to 
a SCSI CDB? How about documenting the unit of 'timeout'?

Thanks,

Bart.

