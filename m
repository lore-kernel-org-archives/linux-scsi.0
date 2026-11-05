Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793889799;
	b=LqG0ANTAJL/MpSTBGXqG4a5MOtNXsd47G+0I/apYixJMxOAJzT4rgNJ6JCVK1RQ1/2Pz
	 say/UOAdIrXWzEJqNJ5xBJT9n6wi1GyLdSDkPzQBOR0GamLSbMJpLQ/5vBnGTRzB6EA74
	 /XkYJhydsBEyAjUumpb+dkRa3HMBIrwahkuV6qCD9jZC5rhcp2U+hKaftp3lRO6ERWB3Q
	 eMfsCXoDStGq6nwnKuB/PV8XHe0osUkKmv2NAjsJ8bd8l2UiNIHeua0OfGP/4E56Y56IF
	 atayXQwJcP7rco3uhNnywdmHyPZIlriIlCr9iiXTxN9RaILD/0LlUtvY2c5kkwu8ByQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793889799;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=wk/So20xr62QzWata5h+JuMn7QiKllnw4EsB0QPRdZA=;
	b=ZSPxnQn3RkC7PlA3PNp6CstzP0xJb5W8i+YXK5AkpqIz0O0qztbc6EYvo7aYIKnD0WO4
	 tFOx6NO90TPJ9R9z/lF4gc9mvM/YCyOvQz4kiZryvp4JXO0/HMjnhn0RD1ndRiSIGns02
	 DRr7PD0y4F63FcDHH3Ri/CTxjQFq3/ksUb6qiXxW9g8Rh/7LM+FRVYGbUfdESvo7lLUYJ
	 Be+nEDjTaKQg7p/qSsaXlVAPb5DrtAXdrRZ/pN7IDvoJTCu/BS2bjbkUYurmfdI+EeHvn
	 02adZiVrHHOO15QhR9SMoTrLp+K7T+clGl876CdeuNmUoP/OCHRjDfFFYEZ4Ax3wPaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NiU6VXsz;
	arc=none smtp.remote-ip=74.125.82.198
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06919606A32C
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 14:43:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06919606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NiU6VXsz
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-36a3451ea93so2735551eec.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 06:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793889793; x=1794494593; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wk/So20xr62QzWata5h+JuMn7QiKllnw4EsB0QPRdZA=;
        b=NiU6VXszwSfPXrvc0ev7LGdQIIoSNzyClwMenodgW9tHkL7rHggh1SXl0iWN7QHbyR
         T7wqatl/b7ghNIDvQjtQP2wfCu/Z5qTCeLEOJ4b9a2zOkEljQsMQ3velrPbzt9xPQD+D
         YuHJm/G+1LGKZY4T6ymn2AFQMNrzJLyhH22hDELC5IAIlodZ8vw7JspNG9VR0s6h9ip/
         lCPlLIjXqPfDHI4Cr7ZW4z0d+dw+u13ff5R/laSywid6YhxqMGrG1liqG9CkOqhGFcfb
         IBABQDwHDmm1eSNB/msmmRVJmLsfBGD1V2pfRpPkrdmAkT0vFlJ8hrPWmaRaEhulaY2E
         zkgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793889793; x=1794494593;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wk/So20xr62QzWata5h+JuMn7QiKllnw4EsB0QPRdZA=;
        b=mJQ8qzqL21Wd0YZ1p6gcyzBJ7JOAvQCImwbTvXBH41NIMBthgiC2QIRVdEQMcq7wxI
         j1xP6CXT61qhtaddkw/UN+rjPDr5copAQgbqdURrMR2ww5IQAWVYZVS6kwY8aHxrPyrH
         qw+KviWxSp6s3q1zoEvACkqfIuO+nsBwFqwCJgWw5jMbFbBhjipmA/c70JLSlaBVNrox
         MzcAc3K4cHUE9CUxayp13430O/r0U1d2z1O07+/vVS+j3UjhJ+PI7zh5GlLU8GCSjt32
         XZnhrswtZQPRfYbO50ljlzIq6YP50vkEsUKDKv5dLPaz0h5o1jldCUXcU2A+6xsi35yU
         ZPbA==
X-Forwarded-Encrypted: i=1; AKwUvBz8s1aAg6kgenQE68+H8gcYgS/aJnPOn0q/WGRc0OfVuxyUNoN8dgnGoZZfV8NzRbeqAtH326NJYeaw@vger.kernel.org
X-Gm-Message-State: APuU4Z8zuPH9ltRet67CqU6B2J+HtM9yR51pO+pJB0eQHmEK2g8wvKQI
	/O8ZLqEpQF5L+3otezl12HvxTk8uOzCPKKWCMUipOMpeNFmIJLTp2dO3+JWjO4LaBp3CgZWPLx4
	nAHpUX7rn8qbLukgte9f3cg==
X-Received: from dyu28.prod.google.com ([2002:a05:693c:811c:b0:36a:15cf:f589])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:618b:20b0:35f:2858:aa4b with SMTP id 5a478bee46e88-36a4241b070mr26273635eec.30.1793889792660;
 Thu, 05 Nov 2026 06:43:12 -0800 (PST)
Date: Thu,  5 Nov 2026 22:43:10 +0800
In-Reply-To: <sashiko-outbox-198692@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261105071518.1458428-1-stanleyjhu@google.com>
 <20261105071518.1458428-2-stanleyjhu@google.com> <sashiko-outbox-198692@kernel.org>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
Message-ID: <20261105144310.2626473-1-stanleyjhu@google.com>
Subject: Re: [PATCH 1/2] scsi: ufs: core: Skip redundant variant resume after
 error recovery power-up
From: Stanley Jhu <stanleyjhu@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Brian Norris <briannorris@chromium.org>, 
	Can Guo <can.guo@oss.qualcomm.com>, Peter Wang <peter.wang@mediatek.com>, 
	John Garry <john.garry@linux.dev>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Praveen Talari <praveen.talari@oss.qualcomm.com>, linux-scsi@vger.kernel.org, 
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 05, 2026 at 07:42:29AM +0000, sashiko-bot@kernel.org wrote:
> If a subsequent __ufshcd_wl_resume()
> fails (for example, in ufshcd_set_dev_pwr_mode()), it rolls back to
> vendor_suspend: and exits through out:, which clears is_suspended and drops
> the clock-gating hold without a matching ufshcd_hold(hba) on future resume
> attempts:

This review was run without the prerequisite listed in the cover
letter, "scsi: ufs: core: Keep clock-gating hold on failed W-LUN
runtime resume". With it applied, a failed runtime resume keeps
is_suspended and the hold, so active_reqs does not underflow.

> However,
> ufshcd_recover_pm_error() only marks ufs_device_wlun active if
> power.runtime_error is set:

Agreed. This will be fixed in v2.
