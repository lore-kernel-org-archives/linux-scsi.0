Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9230C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 22:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiJDWol (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbiJDWoi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 18:44:38 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD83E1CC
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 15:44:33 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id d24so13897887pls.4
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 15:44:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NQnAmmz1j1kCpQJ2Md+DCctnqJz0WLbUaZcpqhtrrRA=;
        b=o6BfE/WR5btxQWoZ+BfusULGZeMP+HtWS93nGOVxK/ruRQcRrd0CFsQ2XUOf1h0vYE
         O6ZKkwS8FJKBpovyvhl7KbvX+ESHe7VYvP3xMBJOIoMuSGlauX1J8u6WTj5kCCZkByh6
         njlVLDgLyFYcpamLYX6GdYz43WWM63ZLpdWimch54hQGRLT7JdEc848lxG+f3BDIZIP1
         n7fBdDEtAC8SIh4soUF74cWtUKOok3In7JHpju9KMowOuQ92R0oOuu7tJj7QxahqiLqc
         aE1VFjN9KcKWboQ26Jnt+Gii1LET1ElBrbMthKTus73D4oNlQEVnFy5/4VsaZBLsQAUI
         ymaQ==
X-Gm-Message-State: ACrzQf2OXFbPm7v9LY0cTJrgLpvs/WN1F+gNemfd0IKW5CfkNzlHUzID
        BBxWqi5OpxZ6R8G3yl/T9yg=
X-Google-Smtp-Source: AMsMyM7WPNjXwN1QTpgL5aK1du/8mp5rGNi0kP/t5CN55CEfbKaVwwHF7vvrUnSImNw/gRnn+W55xw==
X-Received: by 2002:a17:902:c111:b0:17e:e8fd:f24f with SMTP id 17-20020a170902c11100b0017ee8fdf24fmr13899105pli.138.1664923473241;
        Tue, 04 Oct 2022 15:44:33 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b0017f7c4e2604sm774242plk.296.2022.10.04.15.44.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:44:32 -0700 (PDT)
Message-ID: <3c5ba49b-7266-da01-78b3-e51949066727@acm.org>
Date:   Tue, 4 Oct 2022 15:44:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 11/35] scsi: sd: Convert to scsi_exec_req
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-12-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-12-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:52, Mike Christie wrote:
> scsi_execute* is going to be removed. Convert to scsi_exec_req so
> we pass all args in a scsi_exec_args struct.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
