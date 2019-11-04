Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB8CCA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C43ED20848
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbfKDRqZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:46:25 -0500
Received: from mail-pg1-f169.google.com ([209.85.215.169]:45823 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728188AbfKDRqZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:46:25 -0500
Received: by mail-pg1-f169.google.com with SMTP id w11so1458278pga.12
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:46:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U/Yab5OcXCf8VX3LTJtcfq3p2ZOQ+jYOo9QDK0OWOO0=;
        b=qZj+NOPGNO2N63BZ3JKd2adLFda5Zmk+OJX3TaSCAxFncZUNrXosvBZTDpU5UBpGZn
         BOHkKrePEELc1+eGQT6PW3x84tca7+GZlcU7t2/lVPObdSThIaZe3OwITwgP24JXNOyA
         VqALgzvACyyvb402YdAO8NgMz3P2sSLkO0sRBPf2Or0j7PkhgSVMdJbs351tHA7iyivB
         czxqQpTYXSqyWMO8gJkJgRN848TTI14TWMWjKt4b3PBmt0iRaMgBjwH2oYk7GUcUXIJI
         1w5eIdsgr0ncdotqJavDTK0IwAqbUxicOA1CRoupeuL+9sg0gE0C59jvTQaLWFHWsavt
         zrfw==
X-Gm-Message-State: APjAAAUy0sPEAtQfoR63d+Vwo2/5otiwyamU+ZpemJ98ueJwnQLOzedj
        JyGJV6cdRg4gN59LY8/hnEYmU8OK
X-Google-Smtp-Source: APXvYqxdUaE/3H6xF6iMNgRYyj2F7d2AIcD6TJ2NJAZymOO5xQpz6SmPZCdYTK1cdqA1A6ISkXODzA==
X-Received: by 2002:a17:90a:6583:: with SMTP id k3mr457696pjj.50.1572889584054;
        Mon, 04 Nov 2019 09:46:24 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id q26sm14539941pgk.60.2019.11.04.09.46.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:46:23 -0800 (PST)
Subject: Re: [PATCH 21/52] initio: use standard SAM status definitions
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-22-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <2dfe85f2-1bbf-4230-00ec-91c877bae0e4@acm.org>
Date:   Mon, 4 Nov 2019 09:46:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-22-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/19 1:01 AM, Hannes Reinecke wrote:
> Use standard SAM status definitions and drop the
> driver-defined ones.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

