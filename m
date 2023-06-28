Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1BF1EB64D7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 23:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjF1Xko (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 19:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjF1Xkn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 19:40:43 -0400
Received: from gw.rozsnyo.com (gw.rozsnyo.com [77.240.102.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C60C132
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 16:40:40 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by gw.rozsnyo.com (Postfix) with ESMTP id 62C9E1036BA6;
        Thu, 29 Jun 2023 01:40:40 +0200 (CEST)
X-Virus-Scanned: amavisd-new at rozsnyo.com
Received: from gw.rozsnyo.com ([127.0.0.1])
        by localhost (hosting.rozsnyo.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wVEh_rY8Ms6t; Thu, 29 Jun 2023 01:40:39 +0200 (CEST)
Received: from [192.168.68.7] (gw.rozsnyo.com [77.240.102.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by gw.rozsnyo.com (Postfix) with ESMTPSA id 9F96A1036B98;
        Thu, 29 Jun 2023 01:40:39 +0200 (CEST)
Message-ID: <97f19b02-045a-825c-6a30-18fc3dcb35cd@rozsnyo.com>
Date:   Thu, 29 Jun 2023 01:40:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RFC] Support for Write-and-Verify only drives
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
References: <c6499ed7-d049-5714-f827-734cff3f6305@rozsnyo.com>
 <eca63b83-1cf4-40ac-114d-f23acc7cadea@acm.org>
From:   =?UTF-8?Q?Daniel_Rozsny=c3=b3?= <daniel@rozsnyo.com>
In-Reply-To: <eca63b83-1cf4-40ac-114d-f23acc7cadea@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQpPbiA2LzI5LzIzIDAwOjU0LCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+IE9uIDYvMjYv
MjMgMTM6MzUsIERhbmllbCBSb3pzbnnDsyB3cm90ZToNCj4+IMKgwqDCoCBUaGVyZSBhcmUg
c29tZSBkcml2ZXMsIG9yIG1vcmUgcHJlY2lzZWx5IC0gbm9ybWFsIGRyaXZlcyB3aXRoIGEg
Y3VzdG9tIGZpcm13YXJlLCB0aGF0IHNpbXBseSByZWplY3QgYSByZWd1bGFyIFdyaXRlIC0g
bGlrZWx5IGFzIG5vdCBiZWluZyBnb29kIGVub3VnaCBmb3IgdGhlIGludGVuZGVkIGhpZ2gt
cmVsIGFwcGxpY2F0aW9uIC0gd2hpY2ggSSBjYW4gdW5kZXJzdGFuZCwgYnV0IGV2ZW4gYWZ0
ZXIgcmVmb3JtYXR0aW5nIHRoZSBkcml2ZSB0byBuby1QSSBhbmQgZ29pbmcgdG8gInBvb3Ii
IDUxMkIgc2VjdG9yIA0KPj4gc2l6ZSwgdGhleSBzdGlsbCByZWZ1c2UgdG8gZG8gYW4gZWFz
eSBXcml0ZSBvcGVyYXRpb24uIEkgaGFkIHZlcmlmaWVkIHRoYXQgYnkgdXNpbmcgdGhlIHNn
X3dyaXRlX3ZlcmlmeSAodGhhdCB1c2VzIGFuIGlvY3RsKSBJIGNhbiByZWFsbHkgd3JpdGUg
ZGF0YSB0byB0aGVzZSBkcml2ZXMuIFRoZSByZWFkaW5nIHBhdGggaXMgd29ya2luZyBva2F5
IGFuZCBib3RoIGRkIGFuZCBoZHBhcm0gd29ya3MgYXQgZXhwZWN0ZWQgc3BlZWRzLg0KPg0K
PiBUbyBtZSB0aGUgYWJvdmUgc291bmRzIGxpa2UgdGhlIGRyaXZlIGZpcm13YXJlIGlzIGJy
b2tlbi4gUGxlYXNlIGZpeCB0aGUgZHJpdmUgZmlybXdhcmUgYW5kIG1ha2Ugc3VyZSB0aGF0
IFdSSVRFIGNvbW1hbmRzIGFyZSBhY2NlcHRlZC4NCg0KDQpJdCBpcyBub3QgYnJva2VuIC0g
aXQgaXMgYnkgZGVzaWduLiBPciBjYWxsIGl0IGEgZmVhdHVyZSAoYWx0aG91Z2ggaXQgd291
bGQgYmUgbmljZSB0byBoYXZlIGEgY29uZmlndXJhYmxlIGZsYWcgdGhhdCBjb250cm9scyB0
aGUgcmVqZWN0aW9uIG9uIHRoZSBkcml2ZSBzaWRlKS4NCg0KDQpTYW1lIHByaW5jaXBsZSBh
cyBpcyBpbiBwbGFjZSBmb3IgbW9yZSB0aGFuIGEgZGVjYWRlIHdpdGggc2VydmVyIEJJT1Nl
cyAoZWcgZnJvbSBTdXBlcm1pY3JvKSBpbnNpc3Rpbmcgb24gdXNpbmcgRUNDIGVxdWlwcGVk
IG1lbW9yeSAtIG90aGVyd2lzZSBhIHNwZWNpZmljIFBPU1QgY29kZSBoYXBwZW5zIGFuZCB0
aGUgbWFjaGluZSB3b250IHN0YXJ0LCBldmVuIHRoYXQgbm9uLUVDQyBvbmUgd291bGQgYmUg
ZmluZSBvbiB0aGUgZ2l2ZW4gQ1BVL0lNQyAoYW5kIGluZGVlZCBkb2VzIHJ1biBvbiBvdGhl
ciBicmFuZHMpLg0KDQoNCihJUk9OWSBPTikgSWYgeW91ciBhcHByb2FjaCBpcyBzbyAic2lt
cGxlIiAtIGNvdWxkIHlvdSBqdXN0ICJzaW1wbHkiIGJhbiBmcm9tIExpbnV4IGEgY29tcGxl
dGUgbGluZXVwIG9mIDIgbWFqb3IgaGFyZCBkcml2ZSB2ZW5kb3JzIChTZWFnYXRlLCBIR1NU
KSwgdW50aWwgdGhleSBkbyBmaXggbXkgcGFydGljdWxhciBmaXJtd2FyZT8gU3VyZSB3ZSBk
byBub3Qgd2FudCB0byBzdXBwb3J0IHRoZXNlIGluY29tcGV0ZW50IGRyaXZlIG1ha2VycyB0
aGF0IHNoaXAgZHJpdmVzIHdpdGggYSBwb3RlbnRpYWxseSAiYnJva2VuIiANCmZ3LiAoSVJP
TlkgT0ZGKQ0KDQoNCkkgY291bGQgY29udGFjdCB0aGUgdmVuZG9ycywgYnV0IHRoZSBmaXJt
d2FyZSBpcyBub3QgbWFkZSBmb3IgbWUgLSBzbyBJIGhhdmUgbmF0dXJhbGx5IG5vIGNvbnRy
b2wgb3ZlciBpdC4gQW5kIHRoZSBkcml2ZSBkb2VzIG5vdCBhY2NlcHQgYSBmaXJtd2FyZSBm
bGFzaCB0byBpdHMgb3duIGdlbmVyaWMgZmlybXdhcmUgZmFtaWx5IChub3cgdGhhdCBJIHdv
dWxkIHNheSB0aGF0IHdlbnQgYSBiaXQgdG9vIGZhcikuDQoNCg0KU28gY291bGQgd2UgYXQg
bGVhc3QgZmluZCBhbnkgcmVmZXJlbmNlIGZyb20gYSBUMTAgY29tbWl0dGVlIC0gaG93IHRo
ZXkgY2xhc3NpZnkgdGhlIFdSSVRFIGNvbW1hbmQ/DQoNCi0gaXMgaXQgYmVpbmcgYSBtYW5k
YXRvcnkgb3BlcmF0aW9uPyBJcyB0aGF0IHdyaXR0ZW4gaW4gYW55IFNQQy9TQkMgc3BlYz8N
Cg0KDQpPaCAtIEkgZGlkIGl0OiBodHRwczovL3d3dy50MTAub3JnL2xpc3RzL29wLWFscGgu
aHRtIGFuZCB5b3Ugd29udCBiZSBoYXBweToNCg0KVGhlIFdSSVRFKDEwKSBpcyAqT1BUSU9O
QUwqIGZvciBhIERpcmVjdCBBY2Nlc3MgQmxvY2sgRGV2aWNlIChTQkMtNCkNCg0KLSBzbyBu
b3BlLCB0aGUgZmlybXdhcmUgd2hpY2ggaGFzIG5vIFdSSVRFIGNvbW1hbmQgaXMgTk9UIGJy
b2tlbiBhY2NvcmRpbmcgdG8gdGhlIFQxMCBzdGFuZGFyZHMuDQoNCg0KTGV0cyBnZXQgYmFj
ayB0byB0aGUgb3JpZ2luYWwgcmVxdWVzdC9xdWVzdGlvbiB0aGVuLiBXaGF0IGlzIHRoZSBw
cm9wZXIgYXBwcm9hY2ggdG8gaGFuZGxlIHN1Y2ggY29tbWFuZCB2YXJpYXRpb24/DQoNCkRh
bmllbA0KDQo=
