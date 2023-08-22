Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9DEEE49AD
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Aug 2023 01:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjHWBn0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 21:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbjHWBnY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 21:43:24 -0400
X-Greylist: delayed 917 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Aug 2023 18:43:22 PDT
Received: from symantec4.comsats.net.pk (symantec4.comsats.net.pk [203.124.41.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60089E4B
        for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2023 18:43:22 -0700 (PDT)
X-AuditID: cb7c291e-055ff70000002aeb-4c-64e54bbc0cfb
Received: from iesco.comsatshosting.com (iesco.comsatshosting.com [210.56.28.11])
        (using TLS with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by symantec4.comsats.net.pk (Symantec Messaging Gateway) with SMTP id AA.FB.10987.CBB45E46; Wed, 23 Aug 2023 04:58:52 +0500 (PKT)
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns;
        d=iesco.com.pk; s=default;
        h=received:content-type:mime-version:content-transfer-encoding
          :content-description:subject:to:from:date:reply-to;
        b=OsGDCA0jUmfFV416pfSvOEHyj+x1RHWpx4TZ9wJyaamdXA0DNCOBi7Lzsiz5mKgc2
          312etZme+5rFJAHH01pugaJFFD6YsKe0AB/xRRwrwj9b8qDuVVXFPnQOyFbLOBsSl
          +wd7qT7ytD0RiR9fIl7C7MVQ4540d4N4Ih8oxSlA4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iesco.com.pk; s=default;
        h=reply-to:date:from:to:subject:content-description
          :content-transfer-encoding:mime-version:content-type;
        bh=GMzYzcyTxDsE6wX/XHG6MHqAdAiHrhqbmmLQ/TZ1QnQ=;
        b=c5lowGFTesFUnA7k6H+UJi9vX3NpsvZkAxrKVg6QwS0CWmP3Xonwu0/yx62AtQuyv
          I12dpGwBErhWsuKZRWHTyhPF9dUvi0POhaYOUSGtz9qhSqBvS8bfBiogspcBwvb/b
          OlGdfYUTX8rwFbhJTs46eu08arLIwjAwZbG5PUAG4=
Received: from [94.156.6.90] (UnknownHost [94.156.6.90]) by iesco.comsatshosting.com with SMTP;
   Wed, 23 Aug 2023 04:31:07 +0500
Message-ID: <AA.FB.10987.CBB45E46@symantec4.comsats.net.pk>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Re; Interest,
To:     linux-scsi@vger.kernel.org
From:   "Chen Yun" <pso.chairmanbod@iesco.com.pk>
Date:   Tue, 22 Aug 2023 16:31:21 -0700
Reply-To: chnyne@gmail.com
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVyyUKGW3eP99MUg83H5Sy6r+9gc2D0+LxJ
        LoAxissmJTUnsyy1SN8ugStjyboLLAW7mSva+hexNDA+Zupi5OSQEDCReDrvF2sXIxeHkMAe
        Joknh/YygzgsAquZJVas3cYG4Txklrjz+wkrSIuQQDOjxKEjmiA2r4C1xOe7ZxlBbGYBPYkb
        U6ewQcQFJU7OfMICEdeWWLbwNdBUDiBbTeJrVwlIWFhATOLTtGXsILaIgJzE5uVfwcrZBPQl
        VnxtBhvJIqAqMWPpJHaItVISG6+sZ5vAyD8LybZZSLbNQrJtFsK2BYwsqxgliitzE4Ghlmyi
        l5yfW5xYUqyXl1qiV5C9iREYhqdrNOV2MC69lHiIUYCDUYmH9+e6JylCrIllQF2HGCU4mJVE
        eKW/P0wR4k1JrKxKLcqPLyrNSS0+xCjNwaIkzmsr9CxZSCA9sSQ1OzW1ILUIJsvEwSnVwCgQ
        qq/evVBfcOGcIufvB34WzbC+eqBvY8j1uddX7Xvw5+M+hd32d9bWWW1ZcqZfwOqixfa8XJeJ
        a29tSRAx3X1zwbzcuqfLfTNnaG27H/Dw758FK9k/PQ/3XGj6lOPqN/FFfvlpG/r2WJWfvGb+
        LySjoE9Es7aaeapGS5X2T7VDdyuZDvtfW+qmxFKckWioxVxUnAgAhqan/j8CAAA=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Re; Interest,

I am interested in discussing the Investment proposal as I explained
in my previous mail. May you let me know your interest and the
possibility of a cooperation aimed for mutual interest.

Looking forward to your mail for further discussion.

Regards

------
Chen Yun - Chairman of CREC
China Railway Engineering Corporation - CRECG
China Railway Plaza, No.69 Fuxing Road, Haidian District, Beijing, P.R.
China

