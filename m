Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1269EE810A0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 07:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjI0Hzk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 03:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjI0Hzi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 03:55:38 -0400
Received: from jari.cn (unknown [218.92.28.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9AF4EBF;
        Wed, 27 Sep 2023 00:55:36 -0700 (PDT)
Received: from chenguohua$jari.cn ( [182.148.12.64] ) by
 ajax-webmail-localhost.localdomain (Coremail) ; Wed, 27 Sep 2023 15:54:17
 +0800 (GMT+08:00)
X-Originating-IP: [182.148.12.64]
Date:   Wed, 27 Sep 2023 15:54:17 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   chenguohua@jari.cn
To:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aic7xxx: Clean up errors in aic7770.c
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.1-cmXT6 build
 20230419(ff23bf83) Copyright (c) 2002-2023 www.mailtech.cn
 mispb-4e503810-ca60-4ec8-a188-7102c18937cf-zhkzyfz.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <72329742.885.18ad5a1ae7c.Coremail.chenguohua@jari.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AQAAfwDXaD6p3xNlUfS9AA--.575W
X-CM-SenderInfo: xfkh0w5xrk3tw6md2xgofq/1tbiAQAHEWUSpy8AOwAZsK
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rml4IHRoZSBmb2xsb3dpbmcgZXJyb3JzIHJlcG9ydGVkIGJ5IGNoZWNrcGF0Y2g6CgpFUlJPUjog
cmV0dXJuIGlzIG5vdCBhIGZ1bmN0aW9uLCBwYXJlbnRoZXNlcyBhcmUgbm90IHJlcXVpcmVkCgpT
aWduZWQtb2ZmLWJ5OiBHdW9IdWEgQ2hlbmcgPGNoZW5ndW9odWFAamFyaS5jbj4KLS0tCiBkcml2
ZXJzL3Njc2kvYWljN3h4eC9haWM3NzcwLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvYWljN3h4
eC9haWM3NzcwLmMgYi9kcml2ZXJzL3Njc2kvYWljN3h4eC9haWM3NzcwLmMKaW5kZXggMjFmM2Vm
NGFjMjMwLi5iOGQzYjU4ZWVjOTggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9haWM3eHh4L2Fp
Yzc3NzAuYworKysgYi9kcml2ZXJzL3Njc2kvYWljN3h4eC9haWM3NzcwLmMKQEAgLTE2NCw3ICsx
NjQsNyBAQCBhaWM3NzcwX2NvbmZpZyhzdHJ1Y3QgYWhjX3NvZnRjICphaGMsIHN0cnVjdCBhaWM3
NzcwX2lkZW50aXR5ICplbnRyeSwgdV9pbnQgaW8pCiAJCWJyZWFrOwogCWRlZmF1bHQ6CiAJCXBy
aW50aygiYWljNzc3MF9jb25maWc6IGludmFsaWQgaXJxIHNldHRpbmcgJWRcbiIsIGludGRlZik7
Ci0JCXJldHVybiAoRU5YSU8pOworCQlyZXR1cm4gRU5YSU87CiAJfQogCiAJaWYgKChpbnRkZWYg
JiBFREdFX1RSSUcpICE9IDApCi0tIAoyLjE3LjEK
