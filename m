Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA7F5C00144
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 06:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiHDGSc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 02:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiHDGS3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 02:18:29 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CD61EAD1
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 23:18:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 08654402C2;
        Thu,  4 Aug 2022 06:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659593899; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5LRVOawiY224bYDqFfadnMpF/s78eMz6+Ds0bNa5FJA=;
        b=DvGU3nhk4l3gUCSkghWqOZXE7+y9yCaEZVEk3TPfy9lLotrzOPCvv3pDJC3wv1RbiIrOmX
        Ph/U8CTiYdo+JUXt9t0LMp/w2DKsk320fVHUnWtXvqBn7ECzSMJn0fbCPoUeHmfHvOhFF7
        gZwMLRf/mZSvVpEKpBo5yDhn09OnwGo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9B02F1348A;
        Thu,  4 Aug 2022 06:18:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id De1WJKpk62KAegAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 04 Aug 2022 06:18:18 +0000
Message-ID: <b4b91e8b-d6c7-fb5e-6a96-f2b6780dbfe3@suse.com>
Date:   Thu, 4 Aug 2022 08:18:18 +0200
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
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <20220804034100.121125-2-michael.christie@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------N5F739OcGgySqS0mRWbnjhzr"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------N5F739OcGgySqS0mRWbnjhzr
Content-Type: multipart/mixed; boundary="------------PTRtCTgo6MttyMbMUVCEeHzi";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Mike Christie <michael.christie@oracle.com>, njavali@marvell.com,
 pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
 stefanha@redhat.com, oneukum@suse.com, manoj@linux.ibm.com,
 mrochs@linux.ibm.com, ukrishn@linux.ibm.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Message-ID: <b4b91e8b-d6c7-fb5e-6a96-f2b6780dbfe3@suse.com>
Subject: Re: [PATCH 01/10] scsi: xen: Drop use of internal host codes.
References: <20220804034100.121125-1-michael.christie@oracle.com>
 <20220804034100.121125-2-michael.christie@oracle.com>
In-Reply-To: <20220804034100.121125-2-michael.christie@oracle.com>

--------------PTRtCTgo6MttyMbMUVCEeHzi
Content-Type: multipart/mixed; boundary="------------nLc0qbFNejHBq5qzdtZwHEqr"

--------------nLc0qbFNejHBq5qzdtZwHEqr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDQuMDguMjIgMDU6NDAsIE1pa2UgQ2hyaXN0aWUgd3JvdGU6DQo+IFRoZSBlcnJvciBj
b2RlczoNCj4gDQo+IERJRF9UQVJHRVRfRkFJTFVSRQ0KPiBESURfTkVYVVNfRkFJTFVSRQ0K
PiBESURfQUxMT0NfRkFJTFVSRQ0KPiBESURfTUVESVVNX0VSUk9SDQo+IA0KPiBhcmUgaW50
ZXJuYWwgdG8gdGhlIFNDU0kgbGF5ZXIuIERyaXZlcnMgbXVzdCBub3QgdXNlIHRoZW0gYmVj
YXVzZToNCj4gDQo+IDEuIFRoZXkgYXJlIG5vdCBwcm9wYWdhdGVkIHVwd2FyZHMsIHNvIFNH
IElPL3Bhc3N0aHJvdWdoIHVzZXJzIHdpbGwgbm90DQo+IHNlZSBhbiBlcnJvciBhbmQgdGhp
bmsgYSBjb21tYW5kIHdhcyBzdWNjZXNzZnVsLg0KPiANCj4geGVuLXNjc2liYWNrIHdpbGwg
bmV2ZXIgc2VlIHRoaXMgZXJyb3IgYW5kIHNob3VsZCBub3QgdHJ5IHRvIHNlbmQgaXQuDQo+
IA0KPiAyLiBUaGVyZSBpcyBubyBoYW5kbGluZyBmb3IgdGhlbSBpbiBzY3NpX2RlY2lkZV9k
aXNwb3NpdGlvbiBzbyBpZg0KPiB4ZW4tc2NzaWZyb250IHdlcmUgdG8gcmV0dXJuIHRoZSBl
cnJvciB0byBzY3NpLW1sIHRoZW4gaXQga2lja3Mgb2ZmIHRoZQ0KPiBlcnJvciBoYW5kbGVy
IHdoaWNoIGlzIGRlZmluaXRlbHkgbm90IHdoYXQgd2Ugd2FudC4NCj4gDQo+IFRoaXMgcGF0
Y2ggcmVtb3ZlIHRoZSB1c2UgZnJvbSB4ZW4tc2NzaWZyb250L2JhY2suDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBNaWtlIENocmlzdGllIDxtaWNoYWVsLmNocmlzdGllQG9yYWNsZS5jb20+
DQo+IC0tLQ0KPiAgIGRyaXZlcnMvc2NzaS94ZW4tc2NzaWZyb250LmMgICAgICAgfCAgOCAt
LS0tLS0tLQ0KPiAgIGRyaXZlcnMveGVuL3hlbi1zY3NpYmFjay5jICAgICAgICAgfCAxMiAt
LS0tLS0tLS0tLS0NCj4gICBpbmNsdWRlL3hlbi9pbnRlcmZhY2UvaW8vdnNjc2lpZi5oIHwg
MTAgKy0tLS0tLS0tLQ0KPiAgIDMgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDI5
IGRlbGV0aW9ucygtKQ0KPiANCg0KLi4uDQoNCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUveGVu
L2ludGVyZmFjZS9pby92c2NzaWlmLmggYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvaW8vdnNj
c2lpZi5oDQo+IGluZGV4IDdlYTRkYzk2MTFjNC4uNDRlYjFmMzRmMWEwIDEwMDY0NA0KPiAt
LS0gYS9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvaW8vdnNjc2lpZi5oDQo+ICsrKyBiL2luY2x1
ZGUveGVuL2ludGVyZmFjZS9pby92c2NzaWlmLmgNCj4gQEAgLTMxNiwxNiArMzE2LDggQEAg
c3RydWN0IHZzY3NpaWZfcmVzcG9uc2Ugew0KPiAgICNkZWZpbmUgWEVOX1ZTQ1NJSUZfUlNM
VF9IT1NUX1RSQU5TUE9SVF9ESVNSVVBURUQgMTQNCj4gICAvKiBUcmFuc3BvcnQgY2xhc3Mg
ZmFzdGZhaWxlZCAqLw0KPiAgICNkZWZpbmUgWEVOX1ZTQ1NJSUZfUlNMVF9IT1NUX1RSQU5T
UE9SVF9GQUlMRkFTVCAgMTUNCj4gLS8qIFBlcm1hbmVudCB0YXJnZXQgZmFpbHVyZSAqLw0K
PiAtI2RlZmluZSBYRU5fVlNDU0lJRl9SU0xUX0hPU1RfVEFSR0VUX0ZBSUxVUkUgICAgICAx
Ng0KPiAtLyogUGVybWFuZW50IG5leHVzIGZhaWx1cmUgb24gcGF0aCAqLw0KPiAtI2RlZmlu
ZSBYRU5fVlNDU0lJRl9SU0xUX0hPU1RfTkVYVVNfRkFJTFVSRSAgICAgICAxNw0KPiAtLyog
U3BhY2UgYWxsb2NhdGlvbiBvbiBkZXZpY2UgZmFpbGVkICovDQo+IC0jZGVmaW5lIFhFTl9W
U0NTSUlGX1JTTFRfSE9TVF9BTExPQ19GQUlMVVJFICAgICAgIDE4DQo+IC0vKiBNZWRpdW0g
ZXJyb3IgKi8NCj4gLSNkZWZpbmUgWEVOX1ZTQ1NJSUZfUlNMVF9IT1NUX01FRElVTV9FUlJP
UiAgICAgICAgMTkNCj4gICAvKiBUcmFuc3BvcnQgbWFyZ2luYWwgZXJyb3JzICovDQo+IC0j
ZGVmaW5lIFhFTl9WU0NTSUlGX1JTTFRfSE9TVF9UUkFOU1BPUlRfTUFSR0lOQUwgIDIwDQo+
ICsjZGVmaW5lIFhFTl9WU0NTSUlGX1JTTFRfSE9TVF9UUkFOU1BPUlRfTUFSR0lOQUwgIDE2
DQoNClBsZWFzZSBkcm9wIHRoZSBtb2RpZmljYXRpb25zIG9mIHRoaXMgaGVhZGVyLg0KDQpU
aGlzIGlzIGEgY29weSBvZiB0aGUgbWFzdGVyIGZyb20gdGhlIFhlbiByZXBvc2l0b3J5LiBJ
dCBtaWdodCBiZSB1c2VkDQppbiBtdWx0aXBsZSBPUydlcyBhY3Jvc3MgbWFueSByZWxlYXNl
cywgc28gaXQgbmVlZHMgdG8gYmUgcmVnYXJkZWQgYXMgQUJJLg0KDQoNCkp1ZXJnZW4NCg==

--------------nLc0qbFNejHBq5qzdtZwHEqr
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------nLc0qbFNejHBq5qzdtZwHEqr--

--------------PTRtCTgo6MttyMbMUVCEeHzi--

--------------N5F739OcGgySqS0mRWbnjhzr
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmLrZKoFAwAAAAAACgkQsN6d1ii/Ey/5
ugf+IHnMwdl6hbMnVkFlkDQsr19WUzjNtgSG/LjpIQn3CzvFHbQ1O3qe4DjSy/UGjLpBqQLHaA5z
nmOkblyM1KEzY4aiHrhOipHN3lDAftyDLqZXd6go7Mea+pVIJcaribTwJ56xff/0rk/IFxshBK/T
ZvpoqK7PBWWuJfJkewBpJUJFK/lmnJ71DvxoqPUs6nyXpZQ+qLl0adDgN8i/LzolX5+JQTxz9LqT
X4i6Od+hV7clKlj6GHq30gmtnmB32gUyAz3+sGvuS6uVFlh1U2CdO6waHo8sDxRzpd85gEpRRiud
FH4yajt7MxmQiP9lfuBmcHejZXhfOLy8DZ/o0rozsw==
=+lla
-----END PGP SIGNATURE-----

--------------N5F739OcGgySqS0mRWbnjhzr--
