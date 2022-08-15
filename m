Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A5D0C2BBC5
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Aug 2022 06:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240755AbiHOGMp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Aug 2022 02:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241090AbiHOGMa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2022 02:12:30 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9906718E28
        for <linux-scsi@vger.kernel.org>; Sun, 14 Aug 2022 23:12:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 52B6E1F88F;
        Mon, 15 Aug 2022 06:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660543948; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Lf/XpaB7V45kCOL6S4MbegE1GxDXd7eMi33yd+qwAVk=;
        b=uf3ENOfwwJ/Cbjtm3xP45+CTQ4wVbgPuPfPP0j1FcMyl4Jx6i9NSwCMQ0KgyHmd+ohARd0
        SAtWVfp03cjmxgXBW9n1zb5pMY1UmdWxwPcNf6IDpiTalGxRkZmYKpuL4vUyPy8E85j68e
        krHmaQ4KYrxdnjsbrfh8dTSQ9TuAFyE=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E7F8E13A99;
        Mon, 15 Aug 2022 06:12:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CYAXN8vj+WJtCgAAMHmgww
        (envelope-from <jgross@suse.com>); Mon, 15 Aug 2022 06:12:27 +0000
Message-ID: <cae6f56c-8986-efe2-a5f5-a9fe95383277@suse.com>
Date:   Mon, 15 Aug 2022 08:12:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 01/10] scsi: xen: Drop use of internal host codes
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, njavali@marvell.com,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        stefanha@redhat.com, oneukum@suse.com, mrochs@linux.ibm.com,
        ukrishn@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20220812010027.8251-1-michael.christie@oracle.com>
 <20220812010027.8251-2-michael.christie@oracle.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <20220812010027.8251-2-michael.christie@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------iIySmlLuK0FuapaDzzIXNQWO"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------iIySmlLuK0FuapaDzzIXNQWO
Content-Type: multipart/mixed; boundary="------------URTiemTJCObAmOqZbLCElTDr";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Mike Christie <michael.christie@oracle.com>, njavali@marvell.com,
 pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
 stefanha@redhat.com, oneukum@suse.com, mrochs@linux.ibm.com,
 ukrishn@linux.ibm.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Message-ID: <cae6f56c-8986-efe2-a5f5-a9fe95383277@suse.com>
Subject: Re: [PATCH v2 01/10] scsi: xen: Drop use of internal host codes
References: <20220812010027.8251-1-michael.christie@oracle.com>
 <20220812010027.8251-2-michael.christie@oracle.com>
In-Reply-To: <20220812010027.8251-2-michael.christie@oracle.com>

--------------URTiemTJCObAmOqZbLCElTDr
Content-Type: multipart/mixed; boundary="------------8Nbssc3e8qwAXdKchZPGXzsK"

--------------8Nbssc3e8qwAXdKchZPGXzsK
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTIuMDguMjIgMDM6MDAsIE1pa2UgQ2hyaXN0aWUgd3JvdGU6DQo+IFRoZSBlcnJvciBj
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
DQoNClJldmlld2VkLWJ5OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+DQoNCg0K
SnVlcmdlbg0K
--------------8Nbssc3e8qwAXdKchZPGXzsK
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------8Nbssc3e8qwAXdKchZPGXzsK--

--------------URTiemTJCObAmOqZbLCElTDr--

--------------iIySmlLuK0FuapaDzzIXNQWO
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmL548sFAwAAAAAACgkQsN6d1ii/Ey+X
Jgf+McBqSPGWaUp054IzKYiH7AALDT031JQRAMv6hTqnzf6M/ehTOXuB/NlvP/fWgyZuU6HJE3z1
F66uwkT3Z+OzB4kMk/qeWeleEk4RKcSeaXcI8EV8wlxSzp7StIQyorRkctGBqBoyyK55XdiDxDo+
x1qSJeloBmtG/PNSbUDCineBRgO0BWn9RuMw6fjoBGI7wLJaUY3Hw188vMG+qDNe0jM+1GDEXO1R
PKwHhNWHX1vlznHmX8IJVl1N/nzBP2Y+ULs8lq3amPN6P4LLkNXhyBkhE2FCzGRv4HLh0u4C6/zE
96xmQ4WL0vW8BAZFWJnSj523wm04AzJE5ss4eQOSGQ==
=9Yqn
-----END PGP SIGNATURE-----

--------------iIySmlLuK0FuapaDzzIXNQWO--
