From: ersatz splatt <ersatzsplatt@gmail.com>
Subject: Re: [PATCH 0/3] RFC: libsas queuecommand fixups
Date: Tue, 12 Jul 2011 15:10:49 -0700
Message-ID: <CAHQAjVGMJtHu0+scbOhkHwAoW0U2AQDS2A0yGUzhxRQxUQMB+A@mail.gmail.com>
References: <20110711184922.859239377@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34869 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab1GLWKw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2011 18:10:52 -0400
Received: by wwe5 with SMTP id 5so5381868wwe.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2011 15:10:51 -0700 (PDT)
In-Reply-To: <20110711184922.859239377@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

I ran some simple tests (see the recent pm8001 e-mail for specifics)
-- fio on each of the patches applied incrementally to libsas.  This
is only a simple "smoke test" really.
Things seemed to work fine with the patches.

If someone wants some more specific testing, I'm open to running it if
you give me the details.



On Mon, Jul 11, 2011 at 11:49 AM, Christoph Hellwig <hch@infradead.org>=
 wrote:
> Fix up some lose ends in sas_queuecommand that I noticed during the i=
sci
> review. =A0The first two are pretty straight forward, but the third i=
s a bit
> more nasty and needs some serious review and testing. =A0Note that I =
could
> only compile-test the bunch as I don't actually have a SAS controller
> using libsas.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
