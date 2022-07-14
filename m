Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E5EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 23:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240618AbiGNX4w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 19:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiGNX4u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 19:56:50 -0400
Received: from m151.mail.126.com (m151.mail.126.com [220.181.15.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 43F3666ADD
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 16:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=G7GRC
        GqIAa39bfUTQmwIK6WlfSBgba7n712HyAla33g=; b=cGTAeBnbG6QPLmuUDSIFj
        vvjtk9T0sGUQ0d7T477O7vbI5JM9kJAvclIfAA1XiBXNg7EcvQdi3qXmr6QdIS3W
        XtP9yp3ObrVAz/3I7jvUNC4+zYEeRhpJi2d6OG+tp3DNoGf7D3KAHblNGJWugcdo
        kqrocBOwvEPP6CyIfHvIeM=
Received: from windhl$126.com ( [124.16.139.61] ) by ajax-webmail-wmsvr1
 (Coremail) ; Fri, 15 Jul 2022 07:56:38 +0800 (CST)
X-Originating-IP: [124.16.139.61]
Date:   Fri, 15 Jul 2022 07:56:38 +0800 (CST)
From:   "Liang He" <windhl@126.com>
To:     "Bart Van Assche" <bvanassche@acm.org>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re:Re: [PATCH] ufs: host: ufschd-pltfrm: Hold reference returned by
 of_parse_phandle()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <d5f800ea-09c2-b677-ffb6-3d6f2c294115@acm.org>
References: <20220714055413.373449-1-windhl@126.com>
 <d5f800ea-09c2-b677-ffb6-3d6f2c294115@acm.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <72cd069b.136.181ff249c3e.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AcqowACnwLA3rdBiBRgiAA--.12746W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbi7RY+F1pEAZiqAQABs-
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

CkF0IDIwMjItMDctMTUgMDI6MTU6MTIsICJCYXJ0IFZhbiBBc3NjaGUiIDxidmFuYXNzY2hlQGFj
bS5vcmc+IHdyb3RlOgo+T24gNy8xMy8yMiAyMjo1NCwgTGlhbmcgSGUgd3JvdGU6Cj4+ICtzdGF0
aWMgYm9vbCBpc19vZl9wYXJzZV9waGFuZGxlKGNvbnN0IHN0cnVjdCBkZXZpY2Vfbm9kZSAqbnAs
Cj4+ICsJCQkJCQljb25zdCBjaGFyICpwaGFuZGxlX25hbWUsCj4+ICsJCQkJCQlpbnQgaW5kZXgp
Cj4+ICt7Cj4KPlRoZSBmdW5jdGlvbiBuYW1lIHNvdW5kcyB3ZWlyZCB0byBtZS4gV291bGQgcGhh
bmRsZV9leGlzdHMoKSBwZXJoYXBzIGJlIAo+YSBiZXR0ZXIgbmFtZT8KPgo+VGhhbmtzLAo+Cgo+
QmFydC4KCgpUaGFua3MsIEJhcnQKCgpJIHdpbGwgc2VuZCBhIG5ldyB2ZXJzaW9uIHdpdGggYWJv
dmUgbmFtZS4KCgpUaGFua3MgYWdhaW4sCgoKTGlhbmc=
