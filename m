Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B77E80A9A
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 07:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjI0HYG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 03:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjI0HYG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 03:24:06 -0400
Received: from jari.cn (unknown [218.92.28.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0794C10E;
        Wed, 27 Sep 2023 00:24:04 -0700 (PDT)
Received: from chenguohua$jari.cn ( [182.148.12.64] ) by
 ajax-webmail-localhost.localdomain (Coremail) ; Wed, 27 Sep 2023 15:22:44
 +0800 (GMT+08:00)
X-Originating-IP: [182.148.12.64]
Date:   Wed, 27 Sep 2023 15:22:44 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   chenguohua@jari.cn
To:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] aic7xxx: Clean up errors in queue.h
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.1-cmXT6 build
 20230419(ff23bf83) Copyright (c) 2002-2023 www.mailtech.cn
 mispb-4e503810-ca60-4ec8-a188-7102c18937cf-zhkzyfz.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <262cfc7a.880.18ad584cd79.Coremail.chenguohua@jari.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AQAAfwBn+D1E2BNlSPC9AA--.627W
X-CM-SenderInfo: xfkh0w5xrk3tw6md2xgofq/1tbiAQAHEWUSpy8AOwAKsZ
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rml4IHRoZSBmb2xsb3dpbmcgZXJyb3JzIHJlcG9ydGVkIGJ5IGNoZWNrcGF0Y2g6CgpFUlJPUjog
c3BhY2UgcmVxdWlyZWQgYmVmb3JlIHRoZSBvcGVuIHBhcmVudGhlc2lzICcoJwoKU2lnbmVkLW9m
Zi1ieTogR3VvSHVhIENoZW5nIDxjaGVuZ3VvaHVhQGphcmkuY24+Ci0tLQogZHJpdmVycy9zY3Np
L2FpYzd4eHgvcXVldWUuaCB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9haWM3eHh4L3F1ZXVlLmgg
Yi9kcml2ZXJzL3Njc2kvYWljN3h4eC9xdWV1ZS5oCmluZGV4IGY2ZTk1OGE1Zjk3My4uNzMzOGQ5
M2QyZjk1IDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvYWljN3h4eC9xdWV1ZS5oCisrKyBiL2Ry
aXZlcnMvc2NzaS9haWM3eHh4L3F1ZXVlLmgKQEAgLTE4Nyw3ICsxODcsNyBAQCBzdHJ1Y3QgewkJ
CQkJCQkJXAogI2RlZmluZQlTVEFJTFFfRklSU1QoaGVhZCkJKChoZWFkKS0+c3RxaF9maXJzdCkK
IAogI2RlZmluZQlTVEFJTFFfRk9SRUFDSCh2YXIsIGhlYWQsIGZpZWxkKQkJCQlcCi0JZm9yKCh2
YXIpID0gU1RBSUxRX0ZJUlNUKChoZWFkKSk7CQkJCVwKKwlmb3IgKCh2YXIpID0gU1RBSUxRX0ZJ
UlNUKChoZWFkKSk7CQkJCVwKIAkgICAodmFyKTsJCQkJCQkJXAogCSAgICh2YXIpID0gU1RBSUxR
X05FWFQoKHZhciksIGZpZWxkKSkKIAotLSAKMi4xNy4xCg==
