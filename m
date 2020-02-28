Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2450FC3F2D0
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 08:51:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D487D246AA
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 08:51:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="psui6TuH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgB1Ivo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 03:51:44 -0500
Received: from forward100j.mail.yandex.net ([5.45.198.240]:53268 "EHLO
        forward100j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbgB1Ivo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 03:51:44 -0500
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Feb 2020 03:51:43 EST
Received: from mxback28j.mail.yandex.net (mxback28j.mail.yandex.net [IPv6:2a02:6b8:0:1619::228])
        by forward100j.mail.yandex.net (Yandex) with ESMTP id 9983250E1C13;
        Fri, 28 Feb 2020 11:44:51 +0300 (MSK)
Received: from iva4-bca95d3b11b1.qloud-c.yandex.net (iva4-bca95d3b11b1.qloud-c.yandex.net [2a02:6b8:c0c:4e8e:0:640:bca9:5d3b])
        by mxback28j.mail.yandex.net (mxback/Yandex) with ESMTP id Buqt4zYrVR-ipVi96iI;
        Fri, 28 Feb 2020 11:44:51 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1582879491;
        bh=mESbkvWILcImHEm8xIwzzKeiloKl2fwjAucF+6JCRAw=;
        h=In-Reply-To:From:To:Subject:Cc:Date:References:Message-ID;
        b=psui6TuHOyo5bzjoTKoWupdqiTvHJ/byuxOYq5FcRf6ZoDmRaJJB4yOlYjFZTyMN3
         dit0IbjXovmtt/ATw+U0uuHh+ItdKpoTNprnSAKf0B7Oz3Xn0jI+6HQRDu6REA952V
         h9R1F7ku8NK82Bub8fRVEnIjuoyQsGOe20u3sdP4=
Authentication-Results: mxback28j.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva4-bca95d3b11b1.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id aWPNzKpAAh-ioVis1wX;
        Fri, 28 Feb 2020 11:44:50 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: Linux / mpt3sas support for PCI 1000:0014 (weird device?)
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     MPT-FusionLinux.pdl@broadcom.com,
        Linux SCSI List <linux-scsi@vger.kernel.org>
References: <49751508-48b0-eab4-a371-1b9eded12a19@yandex.ru>
 <CAL2rwxpw+bPg24O4V71dqpyW3aCsOYEGycm0=skBgg8pyBzncQ@mail.gmail.com>
From:   Dmitry Antipov <dmantipov@yandex.ru>
Message-ID: <483f502a-f8c6-79a7-86ba-6e544731b6b3@yandex.ru>
Date:   Fri, 28 Feb 2020 11:44:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAL2rwxpw+bPg24O4V71dqpyW3aCsOYEGycm0=skBgg8pyBzncQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/27/20 8:42 PM, Sumit Saxena wrote:

> 1000:0014 is LSI/Broadcom MegaRAID controller and supported by
> megaraid_sas driver (drivers/scsi/megaraid).

Thanks. But lsiutil isn't expected to work with megaraid_sas, right?

Dmitry
