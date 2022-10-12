Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F897C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Oct 2022 20:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiJLU3F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Oct 2022 16:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiJLU3D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Oct 2022 16:29:03 -0400
Received: from antispam1.zonit.com (antispam1.zonit.com [192.88.205.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3525100BFB
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2022 13:29:02 -0700 (PDT)
X-ASG-Debug-ID: 1665606540-18471ce6bd119000001-ziuLRu
Received: from atlas.zonit.com ([199.88.250.66]) by antispam1.zonit.com with ESMTP id F0Oip12p6mycxVsh for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2022 14:29:00 -0600 (MDT)
X-Barracuda-Envelope-From: toms@zonit.com
X-Barracuda-Effective-Source-IP: UNKNOWN[199.88.250.66]
X-Barracuda-Apparent-Source-IP: 199.88.250.66
Received: from [172.30.2.121] (unknown [172.30.2.121])
        by atlas.zonit.com (Postfix) with ESMTP id 5F2C43A3763
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2022 14:29:00 -0600 (MDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 atlas.zonit.com 5F2C43A3763
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zonit.com; s=atlas;
        t=1665606540; bh=VEpPvJJAFXnJDrrSjbzg3fUwtCJe7EGb7+olzlaTtOY=;
        h=Date:Subject:From:To:References:In-Reply-To:From;
        b=boRPD1fkQlXG+YVLl+Hsr1F7beKa58Qj/ZirAhp3f8GVUCV5unPfdIswaAe2AC6Yq
         PlT8M2LGtY8tPDeuKL6Dfh4Lpxvy6PUrNtSdzNGaFn3ODkp6n3wLTRZGQB2XeugrJu
         xf8VMHSPQbn29+Ol6DxUIJcCXhaD3sfz0Ru9ynMM=
Message-ID: <0b46facf-8c3d-7e30-9923-2ffd429f6575@zonit.com>
Date:   Wed, 12 Oct 2022 14:29:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: Errors with Sun StorageTek STK RAID INT (Adaptec ASR-5805) with
 EL 8.6 driver?
Content-Language: en-US
X-ASG-Orig-Subj: Re: Errors with Sun StorageTek STK RAID INT (Adaptec ASR-5805) with
 EL 8.6 driver?
From:   Tom Spettigue <toms@zonit.com>
To:     linux-scsi@vger.kernel.org
References: <bfee9015-d12d-89d4-d278-439baae3293b@zonit.com>
Autocrypt: addr=toms@zonit.com; keydata=
 xsBNBF89qnoBCADGzTB5IUOH/6fz5DIm4FTIMN6ATEYcTMMU65TAERjkFCC1EXxfRew9h9sp
 Ay6/4bwrg8atjmY6PRDZrF8nXs5wibZNwsORSO6ppqdNqEQT+mkl1tEc7mmShz1MRpHvCWJq
 2YyzdWG153dwr6ER1GH496EeroaDDi1pnFTAHp0gH4Lvo75zMkVfbf92CdMyIvw295YqS0XV
 fB2N025Wa38SBxoP4YqRpD1CuhYeIxlj0PJ844CSTdFVk48YkGd/kpW/L9E3Xl7WxrnXz6/2
 Q8YZbg99RX2j4IWDtVyArprtHilQfUe7w1kl+SFsR8FPeS9ayH2uEDF/lVJv7xaRJXWPABEB
 AAHNHlRvbSBTcGV0dGlndWUgPHRvbXNAem9uaXQuY29tPsLAlAQTAQgAPhYhBEvM5cdoINL1
 Q+Z45vg4tbRdeUsmBQJhICcTAhsDBQkFl7SYBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJ
 EPg4tbRdeUsmadsIAIoRGucz9ZAWt4U3SCR/ZeqpuGRQtz+/h+5Jj+B5t5Bx8uNarYUOy7va
 qKZjE2h3XRznwE6toHJksTCa9I7gwyfbH7I/Fp65A05OTA8HOaI6ZOvVq0MksRZox9w/7iV4
 BMupydzX6br/vNj+a2kgHWCykvos22eMfzeMohnsYMmKkCvo8KTIMjwOwknrWQdsTbZ3kR5h
 CN56kWfdjeM1Nr8GrOn72YQy5Ydchn2agJG3QXQJmBrBLnquaxuOEhC9iHPLjBMgdRrb5BIV
 WyorPd3fCyJW/68wqondZtL5Cuhl7ZDsV4FDSu7eBVjMstqtAUKOMuB8ny6KlCSGi2qyNgrO
 wE0EXz2qegEIAKugsXYAB3+GbcBSlfTvdUZMulO8t+zb/pKE6xhsRQof8JvcN4YCwhYe9Oal
 RiucQjBaf6wBld0sg+j5CpCbRnU3Ph54f4QEWme3gb0yJ23yxRHU3kwDg7LZvQbtbZ02GzcZ
 7TykolBkHV79sU+cxPXkjMtStni+ZdIwVRphlPQZ+DCPJK9f7x9fjF5CqpGeXCyv+SySNOkV
 3/i9NRP/ya1JovPw+hdwLj05D9+ktDfzNxJzYAFs4md73SnzjB7hMNU/SuuB9iXi9cZjx03T
 VITD4M7yMRkaPV1/LuZazNgDpuJcsbCOeurEMVOipm+ft4Hc3lPZrBEjNkOA0ToLAiMAEQEA
 AcLAhgQYAQgAJhYhBEvM5cdoINL1Q+Z45vg4tbRdeUsmBQJhICcTAhsMBQkFl7SYABQJEPg4
 tbRdeUsmCRD4OLW0XXlLJowGB/4/lEgxjDNYyz/E9n3jKW/ppNmrE+7DZjWf+HwIIwot1C9/
 tU8+3Npydeq9jSq8nV2ByPZhjet/+Iw6vO+iGZH6Mqw9XBqLh5YZ/MvGOEhFagNfwDyBohpc
 Amo0A7j4mzLSdYCCzS4ihPqfiLua2zk3t7yQ4UbGxt710WpffREHNwp1SkkNomKnSIfvCScp
 IWmHAZ9PiOlw+unK6vZIWBqR4JVYNRknxtCjLGkgdR4FPOI+UmKfxqyXx6+J6aSMtJnNotQq
 cFSJCMOu7hqCVIbzAtzq5pelSQ67vNTBMA20udYyKf2AcG3Xz1HV7vbwoCcNIpMUsuHA+lod
 4Pt6IX7N
In-Reply-To: <bfee9015-d12d-89d4-d278-439baae3293b@zonit.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Nn8bUdhIpXRvm7uH2BrI8kAi"
X-Barracuda-Connect: UNKNOWN[199.88.250.66]
X-Barracuda-Start-Time: 1665606540
X-Barracuda-URL: https://antispam1.zonit.com:443/cgi-mod/mark.cgi
X-ASG-Orig-Subj: Re: Errors with Sun StorageTek STK RAID INT (Adaptec ASR-5805) with
 EL 8.6 driver?
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at zonit.com
X-Barracuda-Scan-Msg-Size: 2533
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.101373
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Nn8bUdhIpXRvm7uH2BrI8kAi
Content-Type: multipart/mixed; boundary="------------FT5BGs2ZSe0O0IP6h6Sjhd5E";
 protected-headers="v1"
From: Tom Spettigue <toms@zonit.com>
To: linux-scsi@vger.kernel.org
Message-ID: <0b46facf-8c3d-7e30-9923-2ffd429f6575@zonit.com>
Subject: Re: Errors with Sun StorageTek STK RAID INT (Adaptec ASR-5805) with
 EL 8.6 driver?
References: <bfee9015-d12d-89d4-d278-439baae3293b@zonit.com>
In-Reply-To: <bfee9015-d12d-89d4-d278-439baae3293b@zonit.com>

--------------FT5BGs2ZSe0O0IP6h6Sjhd5E
Content-Type: multipart/mixed; boundary="------------Q4gRnEDmBuGKfBi90KmGo0FC"

--------------Q4gRnEDmBuGKfBi90KmGo0FC
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

U29tZSBvZiB0aGUgZXJyb3JzIEkndmUgYmVlbiBnZXR0aW5nOg0KDQpbwqAgODk5Ljg5NTEz
OV0gcHJpbnRfcmVxX2Vycm9yOiA3NSBjYWxsYmFja3Mgc3VwcHJlc3NlZA0KW8KgIDg5OS44
OTUxNDRdIGJsa191cGRhdGVfcmVxZXVlc3Q6IEkvTyBlcnJvciwgZGV2IHNkYSwgc2VjdG9y
IDEzNjM2NDIzMiANCm9wIDB4MDooUkVBRCkgZmxhZ3MgMHgzMDAwIHBoeXNfc2VnIDEgcHJp
byBjbGFzcyAwDQpbwqAgODk5Ljg5ODM1M10gRVhUNC1mcyB3YXJuaW5nOiA1IGNhbGxiYWNr
cyBzdXBwcmVzc2VkDQpbwqAgODk5Ljg5ODUzOF0gRVhUNC1mcyB3YXJuaW5nIChkZXZpY2Ug
ZG0tMCk6IA0KaHRyZWVfZGlyYmxvY2tfdG9fdHJlZTo5ODQ6IGlub2RlICMzNDA5NjkxOiBs
YmxvY2sgMDogY29tbSANCnN5c3RlbWQtdG1wZmlsZSAtNSByZWFkaW5nIGRpcmVjdG9yeSBi
bG9jaw0KDQpPYnZpb3VzbHksIEkgYW0gdXNpbmcgRVhUNCBmb3Igb3VyIGZpbGVzeXN0ZW0g
YXMgb3Bwb3NlZCB0byB0aGUgbmF0aXZlIA0KWEZTIG9mIFJIRUwgOC1iYXNlZCBkaXN0cm9z
IC0gcG9zc2libGUgdGhhdCB0aGUgZHJpdmVyIGRvZXNuJ3QgcGxheSBhcyANCm5pY2Ugd2l0
aCB0aGF0Pw0KDQoNCk9uIDEwLzEyLzIyIDEyOjAzLCBUb20gU3BldHRpZ3VlIHdyb3RlOg0K
PiBIZXkgYWxsIC0NCj4NCj4gV2UgaGF2ZSBhbiBvbGRlciBTdW4gTWljcm9zeXN0ZW1zIFN1
bkZpcmUgeDQyNTAgc2VydmVyIHdpdGggb25lIG9mIA0KPiBTdW4ncyBTVEsgUkFJRCBJTlQs
IGEgcmViYWRnZWQgQWRhcHRlYyBBU1ItNTgwNSAoQ291Z2FyKSBSQUlEIEhCQSB0aGF0IA0K
PiB0YWtlcyB0aGUgYWFjcmFpZCBkcml2ZXIsIGFuZCBJJ20gZ2V0dGluZyBhbGwga2luZHMg
b2YgZXJyb3JzIHdpdGggaXQgDQo+IGluIEFsbWEgTGludXggOC42LiBJIGhhdmUgcGVyZm9y
bWVkIGhhcmR3YXJlIHRlc3RzIG9mIGJvdGggdGhlIA0KPiBzZXJ2ZXIncyBtZW1vcnkgKGl0
IHBhc3NlZCBhIHdlZWtlbmQgb2YgbWVtdGVzdDg2KyBydW5zIG9mIDI0IHBhc3NlcykgDQo+
IGFzIHdlbGwgYXMgYWxsIDE2IG9mIG91ciBTdW4tYnJhbmRlZCBIR1NUIDkwMCBHQiAxMGsg
UlBNIFNBUyBkcml2ZXMgDQo+ICh1c2luZyBTZWFnYXRlJ3MgU2VhVG9vbHMgQm9vdGFibGUs
IGFsbCAxNiBwYXNzZWQgUy5NLkEuUi5ULiBjaGVja3MgYXMgDQo+IHdlbGwgYXMgc2hvcnQg
YW5kIGxvbmcgZHJpdmUgc2VsZi10ZXN0cyksIGFuZCBhbGwgcGFzcyB3aXRoIGZseWluZyAN
Cj4gY29sb3JzIGFjcm9zcyBtdWx0aXBsZSBydW5zIG9mIGV2ZXJ5IHRlc3QuDQo+DQo+IEkg
bm9uZXRoZWxlc3MgYW0gZ2V0dGluZyBhbGwga2luZHMgb2YgZXJyb3JzIG9uIG15IEFsbWEg
TGludXggOC42IA0KPiBpbnN0YWxsIHdpdGggdGhhdCBkZC1hYWNyYWlkLTEuMi4xLTcuZWw4
XzYuZWxyZXBvLmlzbyBkcml2ZXIgb2J0YWluZWQgDQo+IGZyb20gaHR0cHM6Ly9lbHJlcG8u
b3JnL2xpbnV4L2R1ZC9lbDgveDg2XzY0Ly4gSSBkb24ndCBrbm93IGlmIHRoYXQncyANCj4g
dGhlIHdyb25nIGRyaXZlciBvciB3aGF0LCBidXQgSSBnZXQgYmFzaWNhbGx5IG9uZSBzZXNz
aW9uIG9mIHVzYWJsZSANCj4gTGludXgsIGFuZCBvbmNlIEkgcmVib290LCBJIGdldCBhbGwg
a2luZHMgb2YgZXJyb3JzIC0gc2VlIGhlcmU6DQo+DQo+IGh0dHBzOi8vaW1ndXIuY29tL2Ev
cXQyYW53Mw0KPg0KPiAvZGV2L3NkYSBpcyBhIHNpbXBsZSwgdHdvLWRyaXZlIFJBSUQtMSBh
cnJheSAtIGFuZCBJIGhhdmUgdGVzdGVkIG5vdyANCj4gZm91ciBkaWZmZXJlbnQgZHJpdmVz
IGluIHRoYXQgYXJyYXkgaW4gdmFyeWluZyBjb21iaW5hdGlvbnMsIGFuZCBJIGdldCANCj4g
dGhlc2UgZXJyb3JzIGluIGFsbCBvZiB0aGVtLiBJIGV2ZW4gc3dhcHBlZCBvdXQgb3VyIFN1
biBTVEsgUkFJRCBJTlQgDQo+IChDb3VnYXIpIFJBSUQgSEJBIGZvciBhbm90aGVyIG9uZSBv
ZiB0aGUgc2FtZSBtYWtlL21vZGVsLCBhbmQgZ290IHRoZSANCj4gc2FtZSBlcnJvcnMuIE5l
aXRoZXIgdGhlIEFkYXB0ZWMgUkFJRCBCSU9TIHJlcG9ydHMgYW55IHByb2JsZW1zIHdpdGgg
DQo+IHRoZSBhcnJheXMsIG5vciBkb2VzIFNlYVRvb2xzIC0gc28gSSdtIGluY3JlYXNpbmds
eSBkaXNpbmNsaW5lZCB0byANCj4gYmVsaWV2ZSB0aGF0IGFueSBvZiBvdXIgZHJpdmVzIGFy
ZSBiYWQsIEknbSBzdGFydGluZyB0byB0aGluayB0aGlzIGlzIA0KPiBzb21lIGtpbmQgb2Yg
Y29uZmlndXJhdGlvbiBwcm9ibGVtLCBvciBzb21lIGtpbmQgb2YgZHJpdmVyIHByb2JsZW0g
DQo+IHdpdGggdGhlIGRkLWFhY3JhaWQtMS4yLjEtNy5lbDhfNi5lbHJlcG8uaXNvIGFhY3Jh
aWQgZHJpdmVyIHRoYXQgSSdtIA0KPiB1c2luZy4gOlANCj4NCj4gQW55IGlkZWFzPw0KPg0K
LS0gDQpUb20gU3BldHRpZ3VlDQpTdGFmZiBFbmdpbmVlcg0KKDcyMCkgNDA2LTUyNjkNClpv
bml0IFN0cnVjdHVyZWQgU29sdXRpb25zDQp3d3cuem9uaXQuY29tDQoNCg==
--------------Q4gRnEDmBuGKfBi90KmGo0FC
Content-Type: application/pgp-keys; name="OpenPGP_0xF838B5B45D794B26.asc"
Content-Disposition: attachment; filename="OpenPGP_0xF838B5B45D794B26.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBF89qnoBCADGzTB5IUOH/6fz5DIm4FTIMN6ATEYcTMMU65TAERjkFCC1EXxf
Rew9h9spAy6/4bwrg8atjmY6PRDZrF8nXs5wibZNwsORSO6ppqdNqEQT+mkl1tEc
7mmShz1MRpHvCWJq2YyzdWG153dwr6ER1GH496EeroaDDi1pnFTAHp0gH4Lvo75z
MkVfbf92CdMyIvw295YqS0XVfB2N025Wa38SBxoP4YqRpD1CuhYeIxlj0PJ844CS
TdFVk48YkGd/kpW/L9E3Xl7WxrnXz6/2Q8YZbg99RX2j4IWDtVyArprtHilQfUe7
w1kl+SFsR8FPeS9ayH2uEDF/lVJv7xaRJXWPABEBAAHNHlRvbSBTcGV0dGlndWUg
PHRvbXNAem9uaXQuY29tPsLAlAQTAQgAPhYhBEvM5cdoINL1Q+Z45vg4tbRdeUsm
BQJhICcTAhsDBQkFl7SYBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJEPg4tbRd
eUsmadsIAIoRGucz9ZAWt4U3SCR/ZeqpuGRQtz+/h+5Jj+B5t5Bx8uNarYUOy7va
qKZjE2h3XRznwE6toHJksTCa9I7gwyfbH7I/Fp65A05OTA8HOaI6ZOvVq0MksRZo
x9w/7iV4BMupydzX6br/vNj+a2kgHWCykvos22eMfzeMohnsYMmKkCvo8KTIMjwO
wknrWQdsTbZ3kR5hCN56kWfdjeM1Nr8GrOn72YQy5Ydchn2agJG3QXQJmBrBLnqu
axuOEhC9iHPLjBMgdRrb5BIVWyorPd3fCyJW/68wqondZtL5Cuhl7ZDsV4FDSu7e
BVjMstqtAUKOMuB8ny6KlCSGi2qyNgrOwE0EXz2qegEIAKugsXYAB3+GbcBSlfTv
dUZMulO8t+zb/pKE6xhsRQof8JvcN4YCwhYe9OalRiucQjBaf6wBld0sg+j5CpCb
RnU3Ph54f4QEWme3gb0yJ23yxRHU3kwDg7LZvQbtbZ02GzcZ7TykolBkHV79sU+c
xPXkjMtStni+ZdIwVRphlPQZ+DCPJK9f7x9fjF5CqpGeXCyv+SySNOkV3/i9NRP/
ya1JovPw+hdwLj05D9+ktDfzNxJzYAFs4md73SnzjB7hMNU/SuuB9iXi9cZjx03T
VITD4M7yMRkaPV1/LuZazNgDpuJcsbCOeurEMVOipm+ft4Hc3lPZrBEjNkOA0ToL
AiMAEQEAAcLAhgQYAQgAJhYhBEvM5cdoINL1Q+Z45vg4tbRdeUsmBQJhICcTAhsM
BQkFl7SYABQJEPg4tbRdeUsmCRD4OLW0XXlLJowGB/4/lEgxjDNYyz/E9n3jKW/p
pNmrE+7DZjWf+HwIIwot1C9/tU8+3Npydeq9jSq8nV2ByPZhjet/+Iw6vO+iGZH6
Mqw9XBqLh5YZ/MvGOEhFagNfwDyBohpcAmo0A7j4mzLSdYCCzS4ihPqfiLua2zk3
t7yQ4UbGxt710WpffREHNwp1SkkNomKnSIfvCScpIWmHAZ9PiOlw+unK6vZIWBqR
4JVYNRknxtCjLGkgdR4FPOI+UmKfxqyXx6+J6aSMtJnNotQqcFSJCMOu7hqCVIbz
Atzq5pelSQ67vNTBMA20udYyKf2AcG3Xz1HV7vbwoCcNIpMUsuHA+lod4Pt6IX7N
=3D6IFn
-----END PGP PUBLIC KEY BLOCK-----

--------------Q4gRnEDmBuGKfBi90KmGo0FC--

--------------FT5BGs2ZSe0O0IP6h6Sjhd5E--

--------------Nn8bUdhIpXRvm7uH2BrI8kAi
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEES8zlx2gg0vVD5njm+Di1tF15SyYFAmNHI4wFAwAAAAAACgkQ+Di1tF15Sybj
VQgAnjj8ao0VGgFXi78RWHiJff4zsrhuO6hVQ59Qdjru4W1EjS9MtIVDtod2ReS4Ju3653zk2AKI
bZMDrHoCuq2qwk8AvCOM6Wb2edIE5YG88/WRcef1mDAgfd9/d0Le9OhwBlXgIlADDqz0GwLWxrIV
5Bfye0Nv/HbPDsl7XKoQg5bqAdz/teTc/Mme3VdKArXDxisKVT8ekt8eLvM/AHv2aFl6dn/AbujP
KAJvtaEkQmsNoOCeCZ7Pwi8KNE1e+AdNsEA95xQcHx6r41/Sgh0Z/srzOGbiQhxZlvWDY/3sYiWG
iC2iUJQKIRwCHxXLCz/US9b234IVXrSRD+JQ4konNA==
=h/U6
-----END PGP SIGNATURE-----

--------------Nn8bUdhIpXRvm7uH2BrI8kAi--
