Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87EA7C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 22:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiJDWqi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiJDWqf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 18:46:35 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB5D5A172
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 15:46:35 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id 8-20020a17090a0b8800b00205d8564b11so181446pjr.5
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 15:46:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=yYwtOh5vG4r4D/X8p5yR2gP4bRrKguEdOtXyXDNEqKQ=;
        b=MAYZjeeluIHgSdH1lj3C/BWgOzHi1PYOlK0V4MU/04eybBOU+s7YlwST+pQg78UveO
         wf3ReDQ1BAMZT8CjBGe9FR6NfvkzQSNJapPMltJJnJL15Ng9TtmjyvCigVpD6N2yHXOC
         SYiZppHUHI//vi37fL427SHnkoraIkHKdpiJcxvHwv1A06uLThfPdSy25OCzAy/d4V09
         su2ValIdh19OOMrWznTAqJ5WMTaSwKYmNpgN8TyMan0ung6HmZ/BSs6LyMyO5HpitlXB
         fgms9oHsMMkCTkyv/1BIouTRMucDSK03e66laGy3GnV5pYhP96depTR0EBBVFky2DiwS
         qkYQ==
X-Gm-Message-State: ACrzQf2t4r4L+mBvWZQCU2cpNd55OC1Pu+pDkUdNa+NEDidBsaAOzHTY
        Ungh2ZAGpX+C3M6JGe22Tcg=
X-Google-Smtp-Source: AMsMyM6XYeVWljxMOJa+bK0LeleyTpqLoFL78gVWtwdi4edcRbkrO4w1vuDcbNH5qxIZZz2kT+z1hQ==
X-Received: by 2002:a17:902:ef96:b0:17e:e7f3:31db with SMTP id iz22-20020a170902ef9600b0017ee7f331dbmr13693984plb.127.1664923594507;
        Tue, 04 Oct 2022 15:46:34 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id w10-20020a627b0a000000b005623a138583sm9630pfc.124.2022.10.04.15.46.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:46:33 -0700 (PDT)
Message-ID: <d54e5b48-76c6-39a3-85a7-740efdc3a73d@acm.org>
Date:   Tue, 4 Oct 2022 15:46:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 15/35] scsi: virtio_scsi: Convert to scsi_exec_req
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-16-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-16-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:53, Mike Christie wrote:
> scsi_execute* is going to be removed. Convert to scsi_exec_req so
> we pass all args in a scsi_exec_args struct.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
