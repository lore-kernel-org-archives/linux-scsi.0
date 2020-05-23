Return-Path: <SRS0=JddF=7F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF25C433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 23 May 2020 10:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07A6920727
	for <linux-scsi@archiver.kernel.org>; Sat, 23 May 2020 10:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387717AbgEWKKp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 May 2020 06:10:45 -0400
Received: from mail.zju.edu.cn ([61.164.42.155]:16444 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725268AbgEWKKp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 23 May 2020 06:10:45 -0400
Received: by ajax-webmail-mail-app4 (Coremail) ; Sat, 23 May 2020 18:10:25
 +0800 (GMT+08:00)
X-Originating-IP: [222.205.77.158]
Date:   Sat, 23 May 2020 18:10:25 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   dinghao.liu@zju.edu.cn
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc:     "kjlu@umn.edu" <kjlu@umn.edu>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        "Avri Altman" <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        "Can Guo" <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RE: RE: [EXT] [PATCH] scsi: ufs-bsg: Fix runtime PM imbalance
 on error
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.10 build 20190906(84e8bf8f)
 Copyright (c) 2002-2020 www.mailtech.cn zju.edu.cn
In-Reply-To: <SN6PR08MB5693D06B4B30D0A76824D2BBDBB40@SN6PR08MB5693.namprd08.prod.outlook.com>
References: <20200522045932.31795-1-dinghao.liu@zju.edu.cn>
 <SN6PR08MB56932A6D579AFB4E28AFD001DBB40@SN6PR08MB5693.namprd08.prod.outlook.com>
 <4a6ba414.bf5c4.1723b9792df.Coremail.dinghao.liu@zju.edu.cn>
 <SN6PR08MB5693D06B4B30D0A76824D2BBDBB40@SN6PR08MB5693.namprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <2ca4e9a1.c1e27.1724103291c.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgBHf3iR9shee3ERAg--.40393W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgQJBlZdtORGcwAIsv
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJTRUUUbtCS07vEb7Iv0x
        C_Cr1lV2xY67kC6x804xWlV2xY67CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DMIAI
        bVAFxVCF77xC64kEw24lV2xY67C26IkvcIIF6IxKo4kEV4ylV2xY628lY4IE4IxF12IF4w
        CS07vE84x0c7CEj48ve4kI8wCS07vE84ACjcxK6xIIjxv20xvE14v26w1j6s0DMIAIbVA2
        z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIAIbVA2z4x0Y4vEx4A2jsIE14v26r
        xl6s0DMIAIbVA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1lV2xY62AIxVAIcxkEcVAq
        07x20xvEncxIr21lV2xY6c02F40EFcxC0VAKzVAqx4xG6I80ewCS07vEYx0E2Ix0cI8IcV
        AFwI0_JrI_JrylV2xY6cIj6I8E87Iv67AKxVWUJVW8JwCS07vEOx8S6xCaFVCjc4AY6r1j
        6r4UMIAIbVACI402YVCY1x02628vn2kIc2xKxwCS07vE7I0Y64k_MIAIbVCY02Avz4vE14
        v_Gw1lV2xY6xkI7II2jI8vz4vEwIxGrwCS07vE42xK82IY6x8ErcxFaVAv8VW8uw4UJr1U
        MIAIbVCF72vE77IF4wCS07vE4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lV2xY6I8I3I0E5I8CrV
        AFwI0_Jr0_Jr4lV2xY6I8I3I0E7480Y4vE14v26r106r1rMIAIbVC2zVAF1VAY17CE14v2
        6r1q6r43MIAIbVCI42IY6xIIjxv20xvE14v26r1j6r1xMIAIbVCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Gr0_Cr1lV2xY6IIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCS07vEIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lV2xY6IIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
        VFxhVjvjDU=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBIaSwgRGluZ2hhbwo+IAo+ID4gVGhhbmsgeW91IGZvciB5b3VyIGFkdmljZSEgTW92aW5nIG9y
aWdpbmFsIHBtX3J1bnRpbWVfcHV0X3N5bmMoKSB0byBhZnRlcgo+ID4gIm91dCIgbGFiZWwgd2ls
bCBpbmZsdWVuY2UgYW4gZXJyb3IgcGF0aCBicmFuY2hlZCBmcm9tCj4gPiB1cHNfYnNnX3Zlcmlm
eV9xdWVyeV9zaXplKCkuIFNvIEkgdGhpbmsgY2hhbmdpbmcgImdvdG8gb3V0IiB0byAiYnJlYWsi
IGlzIGEgZ29vZAo+ID4gaWRlYS4gQnV0IGluIHRoaXMgY2FzZSB3ZSBtYXkgZXhlY3V0ZSBhbiBl
eHRyYQo+ID4gc2dfY29weV9mcm9tX2J1ZmZlcigpIGFuZCBhbiBleHRyYSBrZnJlZSgpIGNvbXBh
cmVkIHdpdGggdW5wYXRjaGVkIHZlcnNpb24uCj4gPiBEb2VzIHRoaXMgbWF0dGVyPwo+ID4gCj4g
V2hhdCBkbyB5b3UgbWVhbiAiIHVucGF0Y2hlZCB2ZXJzaW9uICI/IAo+Cj4gSSBzZWUsIGJlbG93
IGdvdG8gd2lsbCBieXBhc3Mgc2dfY29weV9mcm9tX2J1ZmZlcigpIGFuZCBhbiBleHRyYSBrZnJl
ZSgpCj4gSW4gY2FzZSB1ZnNfYnNnX2FsbG9jX2Rlc2NfYnVmZmVyKCkgZmFpbHMuIAo+IAoKVGhh
dCdzIGV4YWN0bHkgd2hhdCBJIHdhbnQgdG8gZXhwcmVzcy4gSWYgdXNpbmcgImJyZWFrIiBpcyBP
SyBJIHdpbGwgc2VuZAphIG5ldyBwYXRjaCB0byBmaXggdGhpcyBwcm9ibGVtLgoKPiBCZWFuCj4g
CgpSZWdhZWRzLApEaW5naGFvCg==
