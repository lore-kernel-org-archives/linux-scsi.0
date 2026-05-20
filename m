Received: from mta-01.yadro.com (mta-01.yadro.com [195.3.219.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBD33DC4DA;
	Wed, 20 May 2026 18:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.3.219.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300611; cv=none; b=WxRcS61dY4rdnVTlj06J9ZBjfmhSE/OrMm9zFmXR1ZylYvPAwH4I7bPz+2s1LolRd/9uzP6VUN51VKBMnPP/nPZas18CCBtrlQoqBbAsimGozISZWDehUEW9wn7SoCH/6ImznlI8BOsA+VID3FzjFxWyNVw3vlY8j3riNAkLCl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300611; c=relaxed/simple;
	bh=+ol5KnzTLKOm+9Mso/HHGBLurtVhF47wvp2VRu4qCJM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AWr4eE2XHiaYwX4OxWl4OZyNo1YocLS/ubd4YAjBzV9GCFVC7TX4aexv+gbTy4120lIdklnSFHUG+ENVS5X57Et3Owl5I0UDgcG4y0Wk8r4WjO9XYSMp9gz/4jtz4mF8oHi3RBzkp9J+YDIOnFhAWLjn45JWOmPL/OWXLzqL16g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=FTrJESfM; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=YNAXapxk; arc=none smtp.client-ip=195.3.219.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="FTrJESfM";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="YNAXapxk"
Received: from mta-01.yadro.com (localhost [127.0.0.1])
	by mta-01.yadro.com (Postfix) with ESMTP id ED2D52000F;
	Wed, 20 May 2026 21:01:37 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-01.yadro.com ED2D52000F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-02;
	t=1779300097; bh=uBf28UxhSA//HnIANd3fGQ48MKmoNXYDkAY6oPJ6WGE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=FTrJESfM08j/KsgKxm0VtmDgS2Cx/a/aygxg7XhPO9M8MKhXZygOtk3CcT+zJKy3D
	 OVxvocHsTQGtTf8wNzb0cCs60RN4GxTrHYQdkcbnfhJCT0AAcYuzNMhAe2c0zIvcE8
	 MfTCG9/jd7ISEFqza6okvOMDZEyNUgx6BuPKQLD3XMY+wq2pDtE5ne7LeK2gl0sPkQ
	 RfyA3rsbUHWIRCGHlFZ4QIo7dWlvtAjUAyLcLBvJRglAA758p4YQb9vIhOzsCyZhFM
	 l4WDDUKGu54FQi9byGzhErRm+liKRR1TOBSa9nufRkGQh3pBgzMuXIVLodOH9D6jAn
	 OeVIOI96lFKLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1779300097; bh=uBf28UxhSA//HnIANd3fGQ48MKmoNXYDkAY6oPJ6WGE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=YNAXapxkwYb2JG1hShypgus9C2LakclBg24h2pcA3lKStJ30DZFWu4aVkVqvQndTR
	 0qBguea1AsRXmU3VkZOkhnjSrRLsUST5uc/OxVLGJEP39VulhcTBr27QT7P/apjvem
	 RdLVQV51RDFTZO3+DrwxEh8cPSo1Dt0m5pZBU9KbMv00tm4Jkep+/rXCr4gMC8Eu7D
	 wOsKto0JjTK8SsdytkqsmXKlBun7K9Tr9mF7b8XSxFvqOL+zb+nF10Vnetp4dSfdV3
	 iwJo5G2orhFjResapknuZ8QZ8mdxe9+cu51Xb28JcigqkL132/T2lRZDD/Hk0Hai2O
	 8TL0rAZvOHBDA==
Received: from RTM-EXCH-06.corp.yadro.com (unknown [10.34.9.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-01.yadro.com (Postfix) with ESMTPS;
	Wed, 20 May 2026 21:01:36 +0300 (MSK)
Received: from yadro.com (10.34.9.247) by RTM-EXCH-06.corp.yadro.com
 (10.34.9.206) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.35; Wed, 20 May
 2026 21:02:04 +0300
Date: Wed, 20 May 2026 21:02:04 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Alexandru Hossu <hossu.alexandru@gmail.com>, Maurizio Lombardi
	<mlombard@arkamax.eu>
CC: Alexandru Hossu <hossu.alexandru@gmail.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>, <target-devel@vger.kernel.org>,
	<linux-scsi@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: target: iscsi: validate CHAP_R length before
 base64 decode
Message-ID: <20260520180204.GA15940@yadro.com>
References: <20260518121811.385350-1-hossu.alexandru@gmail.com>
 <20260518235040.48647-1-hossu.alexandru@gmail.com>
 <DINMKOIB4PRJ.1Y571RHF6NAQJ@arkamax.eu>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <DINMKOIB4PRJ.1Y571RHF6NAQJ@arkamax.eu>
X-ClientProxiedBy: RTM-EXCH-05.corp.yadro.com (10.34.9.205) To
 RTM-EXCH-06.corp.yadro.com (10.34.9.206)
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2026/05/20 17:18:00 #28193246
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

On Wed, May 20, 2026 at 05:56:05PM +0200, Maurizio Lombardi wrote:
> 
> On Tue May 19, 2026 at 1:50 AM CEST, Alexandru Hossu wrote:
> > chap_server_compute_hash() allocates client_digest as
> > kzalloc(chap->digest_size) and then, for BASE64-encoded responses,
> > passes chap_r directly to chap_base64_decode() without checking whether
> > the input length could produce more than digest_size bytes of output.
> >
> > chap_base64_decode() writes to the destination unconditionally as long
> > as there is input to consume. With MAX_RESPONSE_LENGTH set to 128 and
> > the "0b" prefix stripped by extract_param(), up to 127 base64 characters
> > can reach the decoder. 127 characters decode to 95 bytes. For SHA-256
> > (digest_size=32) this overflows client_digest by 63 bytes; for MD5
> > (digest_size=16) the overflow is 79 bytes.
> >
> > The length check at line 344 fires after the write has already happened.
> >
> > The HEX branch in the same switch statement already validates the length
> > up front. Apply the same approach to the BASE64 branch: reject any input
> > whose maximum decoded length exceeds digest_size before calling the
> > decoder.
> >
> > DIV_ROUND_UP(digest_size * 4, 3) is the maximum number of base64
> > characters that can decode to exactly digest_size bytes, matching the
> > convention used in base64.h BASE64_CHARS().
> >
> > Fixes: 1e5733883421 ("scsi: target: iscsi: Support base64 in CHAP")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
> > ---
> > v2: use DIV_ROUND_UP(digest_size * 4, 3) as suggested by David Disseldorp
> >
> >  drivers/target/iscsi/iscsi_target_auth.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
> > index c46c69a..50eeded 100644
> > --- a/drivers/target/iscsi/iscsi_target_auth.c
> > +++ b/drivers/target/iscsi/iscsi_target_auth.c
> > @@ -341,6 +341,10 @@ static int chap_server_compute_hash(
> >               }
> >               break;
> >       case BASE64:
> > +             if (strlen(chap_r) > DIV_ROUND_UP(chap->digest_size * 4, 3)) {
> > +                     pr_err("Malformed CHAP_R: base64 payload too long\n");
> > +                     goto out;
> > +             }
> 
> 
> There is something that doesn't totally convince me about this length check.
> Couldn't chap_r contain those Base64 padding '=' characters that
> would make strlen(chap_r) too big to pass this check?

Yes, the length of Base64 decoded string is not deterministic.
Moreover, length of Base64 encoded string must be divisible by 4. Which
is biger that 4/3 of decoded.

| diggest_type            | size | size*4/3 | ROUND_UP | encoded with padding |
| ----------------------- | ---- | -------- | -------- | -------------------- |
| MD5_SIGNATURE_SIZE      | 16   | 21,33333 | 22       | 24                   |
| SHA1_SIGNATURE_SIZE     | 20   | 26,66667 | 27       | 28                   |
| SHA256_SIGNATURE_SIZE   | 32   | 42,66667 | 43       | 44                   |
| SHA3_256_SIGNATURE_SIZE | 32   | 42,66667 | 43       | 44                   |

So, that formula is not correct and will break all iscsi authentication.

Alexandru, may be better just to change size of client_diggest variable
to match it with chap_r like for initiatorchg and initiatorchg_binhex?
That will not require any additional length checkings:


--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -273,7 +273,7 @@ static int chap_server_compute_hash(
				goto out;
		}
 
-		client_digest = kzalloc(chap->digest_size, GFP_KERNEL);
+		client_digest = kzalloc(MAX_RESPONSE_LENGTH, GFP_KERNEL);
		if (!client_digest) {
                pr_err("Unable to allocate the client_digest buffer\n");
                goto out;

----


BR,
 Dmitry

