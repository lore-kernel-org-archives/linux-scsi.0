Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.179
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793787882;
	b=OLl4lm3Z2vZbLT3Gk8Z5uzVeX+4lFinXJlSmfN5u3W9p5zdLPhsJ7zEMMCQBywzD18yz
	 G1scDCyfSsL0m3n6QMX66/i/sgJOLNiNedGk59R31wTugWhQ+UTPnmCvM4+UYhsAPoONO
	 idb4VGzk95RRno6lU3aNFq4ZSv+eL8qskx6MMQRJMMx3YF29j5RD1pjW52Vv4xV0INKsx
	 CfsvyJi+UTMzI7wTaMXqCTZ+SJxv/838x/fykqdXPKRtSZvWxHBm+fNvDQUcOE3k5PoCQ
	 vY10AHZqWuUEsvlmUzr7NWY59WE2itS1CMR+xon8XFBwDjnOGeIx1H2z6x+ymfH5pdg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793787882;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:MIME-Version:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=+dcl/erqXSVMqWlciMAxF0/KBcxrMf17dIv8kW6c+wM=;
	b=i0d4nA6d5YDQxGQ66wtdWXOwbj5JTqEg3WbNWTJxAkxgCmrA3mlLOFkw/sJcp+1rhvfF
	 AhYfbyW/cL/hYb3oyW40OYRkhdMuS3QOB0elPbBbk65TMcLm5LrXIDXBEnT/UkO9eRNL7
	 8lwToYieY9XcZGmR+J56lNCreRRI7RNKxj1lv4Ad04q8jOXC/APbYvLQbzQn5sIZ9ltPt
	 zSmWIp/c0TlUrhE8Zj97CiPm7bRs6wgy1LbeBRJ3dL+GOr6x3bPgjctD5hysfjUQuhL9f
	 JqWrRc0zkNYip9KE+lnsdk0JV3qA0TJ5rBZK23I4AEtG2nw3kC5xBA4wt3Tgvh+OqFQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B179lsik;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.179
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EF1606A326
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 10:24:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71EF1606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B179lsik
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3aae7df0971so3881281fa.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 02:24:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793787881; cv=none;
        d=google.com; s=arc-20260327;
        b=L/rixAvnh2jHDaxTLXcKoktZDE9m/4Ywxdqd+yV9vfrhqwZzTM08SovzRo7HdDv7HZ
         ED/3TGmJZvO+1HT1CCcN9wv6+MU47Uv5scqpW5ZTLJkIt41zD2xSGL+tlW9b3fq6rX1j
         gBEnC/1Ja/MdTVToQM5a6thXBlVn/XyUbwJ77mhvJJ7lwkO8sdW6IIpAB1kUfDtGUpFA
         t8VbewS8vJ+qf5Gl+jjVwR77mId+kp/SxZsncJTLT8ZnhvQ0pmoqroS6ETe5w2MzSDue
         VE5dlG7m0jGFPbCCRIbWPK7s1TB9IDdgBUrwXxVDNCfIisXUM16xv9/Ok2Xisebbsk6V
         4PGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=+dcl/erqXSVMqWlciMAxF0/KBcxrMf17dIv8kW6c+wM=;
        fh=8xRMN/hc1vTixGpPt3QhOfDnb0NYtkSrdKpQFJapZoM=;
        b=FG/MT5GrNi6uU2dCFhnluHYSx46yGBQkltogyEi7sr22jdA4Wu25YKWqlvwECn90qz
         s0h+aZRpR8SJKKlb3NXZ8rCpAT4cyGerYUNv1zcePJSH03UmLprrP+XZC1v/GMnZ4Urf
         tVhOXenJkkNuTcywKwZZUACgzpNHPLl+HvdHbVgG4vAtykfU5t3+lUNhsjWzyurCKiZr
         KelCYPm1FDqRb6EE+w+PKZ8zQx/Ijkz1fDo8VvgmF8GW/QEUC0J1yGWaJmp2/oY1nU7x
         DliCKoQcdKu90+Uezl1evB5BnT0oljfVrmlu2mdzB1ILSZrR9HYTsroSV6vXkXPLTYJw
         ca9w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793787881; x=1794392681; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+dcl/erqXSVMqWlciMAxF0/KBcxrMf17dIv8kW6c+wM=;
        b=B179lsikAo3MCoRa+xYIU4+cZtrZXD43+xWjXxmmK7EU5jzixchIfy30KlADnrT861
         iOvQoQm6BBNZdCJEH0Q4WhyLpdI8kZdvfbbQNXoluGnrGFoHLA1WtHksMSh5Z9uI3/N5
         ClWvmr/7fzJhhdoPSfUrsEdt2Vms6hp0PmDFXu9ly9n+lduev3vRRHwF0h0+YmYTcai4
         1mysWtx6OwwvhVco8qHIUWDnpfCe25Ijst9ZbEymg41mIAehVIGkIL/PVYWeT+FnL5zw
         H64u/RUyB3pt8ygIkFMF/DJdsTmn9Q0smb1O8dPO1Ya6tWfIYpkI/Y00oMahoPSz5fH1
         r5SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793787881; x=1794392681;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+dcl/erqXSVMqWlciMAxF0/KBcxrMf17dIv8kW6c+wM=;
        b=gyyOKoGmP7VUre8+9RLkezyDbnGYJ5VtS5oai5By7WL5AfpDIekrwiw0eaw3oKsuWU
         fPNWXlcqT5lMnGhvIFi34h4WpmrF7fHN6H9I3kjlix/NUJ5/hXa808+35FF+YHFscqR5
         oZd9iiUMM0UNm8rQPtGGw+16jTYF5ivkTwIgKsCPEFo/7EC/4uVoahLDrIWc3weXPav+
         hrVRG8OHvjQQWVyFhShvK5TqjaM792nIIWDdVu4f1ZNgcMh72JAzV3iE+XfiGD1yG9nl
         QqmyP5fs42Uj0Mwmurr+iaQxtYgAvoct+i6UZ5UB0348+4H2Leg8V2iQCtutHuxbmAWV
         6xDA==
X-Gm-Message-State: APuU4Z96IaTyLqOJjV2elOw8XzZSw/jPzXct2pUerSjNVLtmdakyZ/l+
	rfaOhPiITAG1p0VablRWDdEW74U63+j3NTcg1raYgV6zpkEINdr8C3I/IkqzUpE2CAc6phKVE1w
	69BUmw022bGKRYsx9usO9UqmZ18tbWdO0Vj7DwpUX8g==
X-Gm-Gg: AYBFou2UnnRWZ0de/b1nTb2K60tgppARDHeD8hQjV7d81Rmv+KjLxvRvue3uvvZEAYl
	6cEOHz1fsRH7FCV+pbZiosIgepaqY9QRukpeKlBZUJN+An8pIIVf+Q+GESHdfDKUFWuwnaiyfao
	pLvMIKzSfBumCgKPdp/9XlvfWnpWOA95YNXqxivAoKuqbqogVS1ZKM/K49CoXfGSTWqaEAiHk3c
	uYDEcP+G2OwC+jzffvbeP2I22EWxytQcd4iXRyLll70XqKXiUpAUZ9KEGYOJoT3jLUkF9fCfUBB
	01uk6+czuQNUV+m+5Q+wh0JroX+/lrB2Jbw0gHDuDfor7Wg/63+NvoPr5SXsmegNcVMKhMpgDR0
	QS13deQvrSLS7Skqi/py8RYpx7TxcaApWREWH5AZwAWkykkWz5p+qNbhMpDj6xX4kkw==
X-Received: by 2002:a05:651c:a345:b0:3ab:3f60:51be with SMTP id
 38308e7fff4ca-3acb7b52404mr37108141fa.28.1793787880322; Wed, 04 Nov 2026
 02:24:40 -0800 (PST)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 4 Nov 2026 05:24:39 -0500
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 4 Nov 2026 05:24:39 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: zhang san <shunsheng1218@gmail.com>
Date: Wed, 4 Nov 2026 05:24:39 -0500
X-Gm-Features: AclHuK8mKYrOLw55T5M7eaMYFOVlEhEP6K_xnwt_-B3_tP11Fu0SQdsrg4zyZZ4
Message-ID: <CAGTEBTZ5teYJyMk3o8-FZ897OsSgwVdFDpvKoKdfA9vR=Bi=-g@mail.gmail.com>
Subject: [BUG/RFC] target: PR ALL_TG_PT traversal can dereference freed LUN
 during removal
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

We found a use-after-free in __core_scsi3_alloc_registration() when a
PR REGISTER AND IGNORE with ALL_TG_PT=1 races a concurrent LUN removal
via configfs.

Problem description:

The function iterates dev->dev_sep_list with
list_for_each_entry_safe() while dropping se_port_lock inside each
iteration body. The current element (lun_tmp) is protected by a
percpu_ref_tryget_live() reference, but the iterator's cached next
pointer is not: if the next se_lun is removed and freed during the
unlocked body, the loop's next iteration dereferences freed memory
through the cached pointer. This manifests as a general protection
fault on a non-canonical address (list poison).

We reproduced this on mainline 6628e7d4c6b2 (v7.4-rc1) with a
KASAN-enabled kernel: a GPF in __core_scsi3_alloc_registration() when
the PR registration races a configfs port deletion. The reproducer
uses controlled timing to expose the interleaving and is available on
request; control runs were clean.

Attempted fix and design question:

We explored taking a percpu_ref_tryget_live() reference on the next
entry before dropping the lock, and releasing it when the iteration
advances. This prevented the observed use-after-free in the tested
interleaving.

However, when the next entry's tryget fails (the LUN is dying and
being removed), there is a functional tradeoff:

  - We cannot safely carry that pointer across the lock drop without a
lifetime guarantee.
  - We cannot obtain a live reference with tryget in this case.
  - Our prototype stops the traversal (break), which may skip later
LUNs that are still valid and should receive ALL_TG_PT registrations.

We therefore do not consider the prototype ready to submit as a fix.

We would appreciate guidance on the correct approach:

  1. Is stopping the iteration when a dying LUN is encountered
acceptable under the target core's PR registration semantics?
  2. Should the traversal instead restart under se_port_lock, using a
safe way to identify and avoid already processed LUNs?
  3. Is there an existing target-core lifetime or traversal mechanism
that should be used instead?

We can provide the prototype patch, KASAN traces, kernel
configuration, and test setup privately if useful. If a fix is
proposed, please CC me so I can test the exact revision and provide a
Tested-by tag if it passes.

This finding comes from an AI-assisted source audit; the source
analysis and injection-assisted tests were reviewed by us.

Best regards,
Yaohan Li
shunsheng1218@gmail.com
