Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1ABFC00A89
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 08:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 994AC2224E
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 08:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604048372;
	bh=V55sGn2rj0SKqKDvY7u2Lm3iopy2BhrGvK4iQIktSRA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:List-ID:From;
	b=ukQfb0DEbDcwsTpUI193nKtWzyyRNz/CFXB2XHlICb9iciKrtaQcwzh3NLeSxHHGv
	 +BxxCuJd/tyJ2G6bvDUf7f+3gxS6PUrIX3iyhD84m0/k/6dsLRl+l/gtBnhxwXYjlK
	 f5HETPqPMdSB0t9/Xz8gH3twiqbsXZjIGSkEt/a8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgJ3I73 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 04:59:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgJ3I72 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Oct 2020 04:59:28 -0400
Received: from saruman (88-113-213-94.elisa-laajakaista.fi [88.113.213.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F61420709;
        Fri, 30 Oct 2020 08:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604048367;
        bh=V55sGn2rj0SKqKDvY7u2Lm3iopy2BhrGvK4iQIktSRA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=dis3A2JGF0hgWYzNCR5xz4msUqzYN+2ufj5b0yk/SDQpM2rzpJAErFfTV26Y7LYtp
         IzicK8ePsep7pwJMLmbQp+FMSv9tIJ30ge3vS2Cale2dEdpyuyo5rYiX8khwF+a4iM
         qNpZyNoCdCrfDbe2bZ9Aq8ieAijnZTtD7+5eyCQs=
From:   Felipe Balbi <balbi@kernel.org>
To:     Luo Jiaxing <luojiaxing@huawei.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, andriy.shevchenko@linux.intel.com
Cc:     linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
        john.garry@huawei.com, himanshu.madhani@cavium.com,
        gregkh@linuxfoundation.org, uma.shankar@intel.com,
        anshuman.gupta@intel.com, animesh.manna@intel.com,
        linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxarm@huawei.com
Subject: Re: [PATCH v2 4/5] usb: dwc3: debugfs: Introduce
 DEFINE_SHOW_STORE_ATTRIBUTE
In-Reply-To: <1604046722-15531-5-git-send-email-luojiaxing@huawei.com>
References: <1604046722-15531-1-git-send-email-luojiaxing@huawei.com>
 <1604046722-15531-5-git-send-email-luojiaxing@huawei.com>
Date:   Fri, 30 Oct 2020 10:59:18 +0200
Message-ID: <87v9esks2h.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Luo Jiaxing <luojiaxing@huawei.com> writes:

> Seq instroduce a new helper marco DEFINE_SHOW_STORE_ATTRIBUTE for
      ^^^^^^^^^^              ^^^^^
      introduce               macro

> Read-Write file, So we apply it at dwc3 debugfs to reduce some duplicate
                   ^^                                            ^^^^^^^^^
                   so                                            duplicated

> code.

to be fair, your commit is doing more than what it claims. Maybe update
commit log with a "while at that, also use DEFINE_SHOW_ATTRIBUTE() where
possible".

> Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>

other than that, this looks okay. Since it depends on the definition of
DEFINE_SHOW_STORE_ATTRIBUTE:

Acked-by: Felipe Balbi <balbi@kernel.org>

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAl+b1eYRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQbfWRAAk6T3bnYboy4kDtezxHaGWWVKcLnjDdre
VHNP4AAPlI6z+jQrT6dkvS+83osjN2LMU+xP2IJdq4ZG6c/DGK/my7PUYiwwDxMk
deH/BM+5v7M9Tit3TJEuM5maPE+I7lwDFPGsdHo5112uoiTE2R8FJaO/bL2cNzM5
W9e/GbIIbLGi/BH01UrOeG1qPvPeb+G2YKlDyHFPZh0xyO6sBOy4WabuW2Uk4adl
Ih5sOSz0DgyYvY/QKqAe+fKVByGluVgRStfNFUGNkKbhCi7s0ga1DkYrlsYs+zYY
zrKdgyq9Wey1JmJ1JQ73PO5t3/94HjhsEEs8FltSZ4J2M6GRZM/hBH4uV/p45on3
zfHuxnqQOxgUslXunWRhrXixlvwWeD8pL4zI6er6Cn7nlSauLYXvasmqjddPfCks
xrijv+fTj7koWujLfKQ65nZY7PpcDszS/pV0URhcKO9X8+XN3IKh1KB1BFRxiuyA
PUh1e8xtegr2YeJqsOpERVbTKhs5U6uFys13I1PbBHKPJ34QPotcRF0DWofQAioe
rdZHxDnqSM8qvFiy21RtvujXQwbP0Yf3VvOlIn5JtlersaXoDEmIjM7TtNVGH+JZ
mNI9t3iiX1w4QUx+VRRn1xkmpIn804eO4V7XlW4R14no+FTEAdjLe7BQM6//TCUm
0j3r+KdUeZ8=
=+rAO
-----END PGP SIGNATURE-----
--=-=-=--
