Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0772DE80A8A
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Sep 2023 02:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjI1CGm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 22:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjI1CGl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 22:06:41 -0400
Received: from jari.cn (unknown [218.92.28.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5941EAC;
        Wed, 27 Sep 2023 19:06:39 -0700 (PDT)
Received: from wangkailong$jari.cn ( [182.148.12.64] ) by
 ajax-webmail-localhost.localdomain (Coremail) ; Thu, 28 Sep 2023 10:05:20
 +0800 (GMT+08:00)
X-Originating-IP: [182.148.12.64]
Date:   Thu, 28 Sep 2023 10:05:20 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "KaiLong Wang" <wangkailong@jari.cn>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: lpfc: Clean up errors in lpfc.h
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.1-cmXT6 build
 20230419(ff23bf83) Copyright (c) 2002-2023 www.mailtech.cn
 mispb-4e503810-ca60-4ec8-a188-7102c18937cf-zhkzyfz.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <221a3afa.89f.18ad9888f69.Coremail.wangkailong@jari.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AQAAfwD3lD9g3xRlEXm+AA--.687W
X-CM-SenderInfo: 5zdqwypdlo00nj6mt2flof0/1tbiAQAJB2T8PZMAAQAZsh
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rml4IHRoZSBmb2xsb3dpbmcgZXJyb3JzIHJlcG9ydGVkIGJ5IGNoZWNrcGF0Y2g6CgpFUlJPUjog
c3BhY2UgcHJvaGliaXRlZCBhZnRlciB0aGF0IG9wZW4gcGFyZW50aGVzaXMgJygnCkVSUk9SOiBz
cGFjZSBwcm9oaWJpdGVkIGJlZm9yZSB0aGF0IGNsb3NlIHBhcmVudGhlc2lzICcpJwoKU2lnbmVk
LW9mZi1ieTogS2FpTG9uZyBXYW5nIDx3YW5na2FpbG9uZ0BqYXJpLmNuPgotLS0KIGRyaXZlcnMv
c2NzaS9scGZjL2xwZmMuaCB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9scGZjL2xwZmMuaCBiL2Ry
aXZlcnMvc2NzaS9scGZjL2xwZmMuaAppbmRleCBhZjE1ZjdhMjJkMjUuLjEwYzk1ZGQ4Nzc1OSAx
MDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL2xwZmMvbHBmYy5oCisrKyBiL2RyaXZlcnMvc2NzaS9s
cGZjL2xwZmMuaApAQCAtODksNyArODksNyBAQCBzdHJ1Y3QgbHBmY19zbGkyX3NsaW07CiAjZGVm
aW5lIHB1dFBhZGRyTG93KGFkZHIpICAgICgodWludDMyX3QpICgweGZmZmZmZmZmICYgKHU2NCko
YWRkcikpKQogI2RlZmluZSBwdXRQYWRkckhpZ2goYWRkcikgICAoKHVpbnQzMl90KSAoMHhmZmZm
ZmZmZiAmICgoKHU2NCkoYWRkcikpPj4zMikpKQogI2RlZmluZSBnZXRQYWRkcihoaWdoLCBsb3cp
ICAoKGRtYV9hZGRyX3QpKCBcCi0JCQkgICAgICgoICh1NjQpKGhpZ2gpPDwxNiApIDw8IDE2KXwo
ICh1NjQpKGxvdykpKSkKKwkJCSAgICAgKCgodTY0KShoaWdoKTw8MTYpIDw8IDE2KXwoKHU2NCko
bG93KSkpKQogLyogUHJvdmlkZSBtYXhpbXVtIGNvbmZpZ3VyYXRpb24gZGVmaW5pdGlvbnMuICov
CiAjZGVmaW5lIExQRkNfRFJWUl9USU1FT1VUCTE2CS8qIGRyaXZlciBpb2NiIHRpbWVvdXQgdmFs
dWUgaW4gc2VjICovCiAjZGVmaW5lIEZDX01BWF9BRFBUTVNHCQk2NAotLSAKMi4xNy4xCg==
