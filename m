Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D806CC25B06
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 17:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237223AbiHDRAH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 13:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237280AbiHDRAE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 13:00:04 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F29267CB8
        for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2022 10:00:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 47560203FE;
        Thu,  4 Aug 2022 17:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659632402; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FwcW2mPAi75EimOmCeg96xupUEbB0Myn/4vih0msLAg=;
        b=jm0GkCqW/9oZ94rrl1qOm0w7DGKmkADhswM3tQZBnnGTn7YFOBPts0EgPrxGwU3PJTtDwF
        YzW6Ct/82wRj0SH1/4p+2m7iSbANyUnEAYGmg1iOAVp4sfIe+T9sv5dVQ0U9/+vuF+HuFm
        tOZIyILGEBvqv5MI6MdBF5l7nm1I6G0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CA83513A94;
        Thu,  4 Aug 2022 17:00:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vY5ZLxH762K9NQAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 04 Aug 2022 17:00:01 +0000
Message-ID: <3a91ea83-1d01-8b78-5318-4fbf4f3373d3@suse.com>
Date:   Thu, 4 Aug 2022 19:00:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 01/10] scsi: xen: Drop use of internal host codes.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, njavali@marvell.com,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        stefanha@redhat.com, oneukum@suse.com, manoj@linux.ibm.com,
        mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220804034100.121125-1-michael.christie@oracle.com>
 <20220804034100.121125-2-michael.christie@oracle.com>
 <b4b91e8b-d6c7-fb5e-6a96-f2b6780dbfe3@suse.com>
 <e037decf-26d1-e60b-2815-9e330d0b6c47@oracle.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <e037decf-26d1-e60b-2815-9e330d0b6c47@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------qxoksAZXDNYHERoFEPmpA0sD"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------qxoksAZXDNYHERoFEPmpA0sD
Content-Type: multipart/mixed; boundary="------------a07xwurgYDnhFFXVRQeqFAOF";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Mike Christie <michael.christie@oracle.com>, njavali@marvell.com,
 pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
 stefanha@redhat.com, oneukum@suse.com, manoj@linux.ibm.com,
 mrochs@linux.ibm.com, ukrishn@linux.ibm.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Message-ID: <3a91ea83-1d01-8b78-5318-4fbf4f3373d3@suse.com>
Subject: Re: [PATCH 01/10] scsi: xen: Drop use of internal host codes.
References: <20220804034100.121125-1-michael.christie@oracle.com>
 <20220804034100.121125-2-michael.christie@oracle.com>
 <b4b91e8b-d6c7-fb5e-6a96-f2b6780dbfe3@suse.com>
 <e037decf-26d1-e60b-2815-9e330d0b6c47@oracle.com>
In-Reply-To: <e037decf-26d1-e60b-2815-9e330d0b6c47@oracle.com>

--------------a07xwurgYDnhFFXVRQeqFAOF
Content-Type: multipart/mixed; boundary="------------LBaUbfldLDOGSJZ7QWvVHRGH"

--------------LBaUbfldLDOGSJZ7QWvVHRGH
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDQuMDguMjIgMTg6MjgsIE1pa2UgQ2hyaXN0aWUgd3JvdGU6DQo+IE9uIDgvNC8yMiAx
OjE4IEFNLCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPj4gT24gMDQuMDguMjIgMDU6NDAsIE1p
a2UgQ2hyaXN0aWUgd3JvdGU6DQo+Pj4gVGhlIGVycm9yIGNvZGVzOg0KPj4+DQo+Pj4gRElE
X1RBUkdFVF9GQUlMVVJFDQo+Pj4gRElEX05FWFVTX0ZBSUxVUkUNCj4+PiBESURfQUxMT0Nf
RkFJTFVSRQ0KPj4+IERJRF9NRURJVU1fRVJST1INCj4+Pg0KPj4+IGFyZSBpbnRlcm5hbCB0
byB0aGUgU0NTSSBsYXllci4gRHJpdmVycyBtdXN0IG5vdCB1c2UgdGhlbSBiZWNhdXNlOg0K
Pj4+DQo+Pj4gMS4gVGhleSBhcmUgbm90IHByb3BhZ2F0ZWQgdXB3YXJkcywgc28gU0cgSU8v
cGFzc3Rocm91Z2ggdXNlcnMgd2lsbCBub3QNCj4+PiBzZWUgYW4gZXJyb3IgYW5kIHRoaW5r
IGEgY29tbWFuZCB3YXMgc3VjY2Vzc2Z1bC4NCj4+Pg0KPj4+IHhlbi1zY3NpYmFjayB3aWxs
IG5ldmVyIHNlZSB0aGlzIGVycm9yIGFuZCBzaG91bGQgbm90IHRyeSB0byBzZW5kIGl0Lg0K
Pj4+DQo+Pj4gMi4gVGhlcmUgaXMgbm8gaGFuZGxpbmcgZm9yIHRoZW0gaW4gc2NzaV9kZWNp
ZGVfZGlzcG9zaXRpb24gc28gaWYNCj4+PiB4ZW4tc2NzaWZyb250IHdlcmUgdG8gcmV0dXJu
IHRoZSBlcnJvciB0byBzY3NpLW1sIHRoZW4gaXQga2lja3Mgb2ZmIHRoZQ0KPj4+IGVycm9y
IGhhbmRsZXIgd2hpY2ggaXMgZGVmaW5pdGVseSBub3Qgd2hhdCB3ZSB3YW50Lg0KPj4+DQo+
Pj4gVGhpcyBwYXRjaCByZW1vdmUgdGhlIHVzZSBmcm9tIHhlbi1zY3NpZnJvbnQvYmFjay4N
Cj4+Pg0KPj4+IFNpZ25lZC1vZmYtYnk6IE1pa2UgQ2hyaXN0aWUgPG1pY2hhZWwuY2hyaXN0
aWVAb3JhY2xlLmNvbT4NCj4+PiAtLS0NCj4+PiAgwqAgZHJpdmVycy9zY3NpL3hlbi1zY3Np
ZnJvbnQuY8KgwqDCoMKgwqDCoCB8wqAgOCAtLS0tLS0tLQ0KPj4+ICDCoCBkcml2ZXJzL3hl
bi94ZW4tc2NzaWJhY2suY8KgwqDCoMKgwqDCoMKgwqAgfCAxMiAtLS0tLS0tLS0tLS0NCj4+
PiAgwqAgaW5jbHVkZS94ZW4vaW50ZXJmYWNlL2lvL3ZzY3NpaWYuaCB8IDEwICstLS0tLS0t
LS0NCj4+PiAgwqAgMyBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMjkgZGVsZXRp
b25zKC0pDQo+Pj4NCj4+DQo+PiAuLi4NCj4+DQo+Pj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUv
eGVuL2ludGVyZmFjZS9pby92c2NzaWlmLmggYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvaW8v
dnNjc2lpZi5oDQo+Pj4gaW5kZXggN2VhNGRjOTYxMWM0Li40NGViMWYzNGYxYTAgMTAwNjQ0
DQo+Pj4gLS0tIGEvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL2lvL3ZzY3NpaWYuaA0KPj4+ICsr
KyBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS9pby92c2NzaWlmLmgNCj4+PiBAQCAtMzE2LDE2
ICszMTYsOCBAQCBzdHJ1Y3QgdnNjc2lpZl9yZXNwb25zZSB7DQo+Pj4gIMKgICNkZWZpbmUg
WEVOX1ZTQ1NJSUZfUlNMVF9IT1NUX1RSQU5TUE9SVF9ESVNSVVBURUQgMTQNCj4+PiAgwqAg
LyogVHJhbnNwb3J0IGNsYXNzIGZhc3RmYWlsZWQgKi8NCj4+PiAgwqAgI2RlZmluZSBYRU5f
VlNDU0lJRl9SU0xUX0hPU1RfVFJBTlNQT1JUX0ZBSUxGQVNUwqAgMTUNCj4+PiAtLyogUGVy
bWFuZW50IHRhcmdldCBmYWlsdXJlICovDQo+Pj4gLSNkZWZpbmUgWEVOX1ZTQ1NJSUZfUlNM
VF9IT1NUX1RBUkdFVF9GQUlMVVJFwqDCoMKgwqDCoCAxNg0KPj4+IC0vKiBQZXJtYW5lbnQg
bmV4dXMgZmFpbHVyZSBvbiBwYXRoICovDQo+Pj4gLSNkZWZpbmUgWEVOX1ZTQ1NJSUZfUlNM
VF9IT1NUX05FWFVTX0ZBSUxVUkXCoMKgwqDCoMKgwqAgMTcNCj4+PiAtLyogU3BhY2UgYWxs
b2NhdGlvbiBvbiBkZXZpY2UgZmFpbGVkICovDQo+Pj4gLSNkZWZpbmUgWEVOX1ZTQ1NJSUZf
UlNMVF9IT1NUX0FMTE9DX0ZBSUxVUkXCoMKgwqDCoMKgwqAgMTgNCj4+PiAtLyogTWVkaXVt
IGVycm9yICovDQo+Pj4gLSNkZWZpbmUgWEVOX1ZTQ1NJSUZfUlNMVF9IT1NUX01FRElVTV9F
UlJPUsKgwqDCoMKgwqDCoMKgIDE5DQo+Pj4gIMKgIC8qIFRyYW5zcG9ydCBtYXJnaW5hbCBl
cnJvcnMgKi8NCj4+PiAtI2RlZmluZSBYRU5fVlNDU0lJRl9SU0xUX0hPU1RfVFJBTlNQT1JU
X01BUkdJTkFMwqAgMjANCj4+PiArI2RlZmluZSBYRU5fVlNDU0lJRl9SU0xUX0hPU1RfVFJB
TlNQT1JUX01BUkdJTkFMwqAgMTYNCj4+DQo+PiBQbGVhc2UgZHJvcCB0aGUgbW9kaWZpY2F0
aW9ucyBvZiB0aGlzIGhlYWRlci4NCj4+DQo+PiBUaGlzIGlzIGEgY29weSBvZiB0aGUgbWFz
dGVyIGZyb20gdGhlIFhlbiByZXBvc2l0b3J5LiBJdCBtaWdodCBiZSB1c2VkDQo+PiBpbiBt
dWx0aXBsZSBPUydlcyBhY3Jvc3MgbWFueSByZWxlYXNlcywgc28gaXQgbmVlZHMgdG8gYmUg
cmVnYXJkZWQgYXMgQUJJLg0KPj4NCj4gDQo+IEhvdyBkbyB5b3Ugd2FudCB0byBoYW5kbGUg
c2NzaWZyb250X2hvc3RfYnl0ZT8NCj4gDQo+IHhlbi1zY3NpYmFjay5jIHdpbGwgbmV2ZXIg
cmV0dXJuIHRob3NlIGVycm9yIGNvZGVzLCBidXQgY2FuIHNvbWUgb3RoZXINCj4gaW1wbGVt
ZW50YXRpb24/IERvIHlvdSB3YW50IG1lIHRvIGFkZCB0cmFuc2xhdGlvbiBmcm9tIHRoZSBY
RU5fVlNDU0lJRg0KPiB0byBzb21lIG90aGVyIERJRCBjb2Rlcz8NCg0KSXRzIGZpbmUgZm9y
IHNjc2lmcm9udCB0byB1c2UgdGhlICJkZWZhdWx0OiIgZmFsbGJhY2sgaW4gdGhpcyBjYXNl
Lg0KDQoNCkp1ZXJnZW4NCg0K
--------------LBaUbfldLDOGSJZ7QWvVHRGH
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------LBaUbfldLDOGSJZ7QWvVHRGH--

--------------a07xwurgYDnhFFXVRQeqFAOF--

--------------qxoksAZXDNYHERoFEPmpA0sD
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmLr+xEFAwAAAAAACgkQsN6d1ii/Ey91
TQf/UTmqZaOtkAGF4rA+sbLxHWe84iXfO0pld0Kcs/DYFDUsRMgKxbSnaOJoss8+w2G3Bwboh1ce
i1bPkb/FlNbyc+Lm+V+YTfO8wqROlVzfbRGrzoPBRcKxMYkA3ZAhqSMS1C1cP5sD2lK8cUYuKJnJ
R63fmC+iazAgZ5YtWOtsCkCvoAGO2bKj+mhuqe/vdcEsxVSC98U2IN0nd6KK/Lz9XG2huibQztqi
/omABBHnmirDeOozDog6LOJVdakRi4mHd7LLp1jpVaUdtpROYIGTqDM3ykzcJVzH5NmjjwKkqpqq
2gUsJ/HFpJGQR18/9fwOCqky/IQMsGJW5set5yzZLw==
=VwVb
-----END PGP SIGNATURE-----

--------------qxoksAZXDNYHERoFEPmpA0sD--
