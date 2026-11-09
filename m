Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184472;
	b=Y2Nb5YdQxxdqrD6so1/IllfIQuEkIsr90d+7KBnlBaGl1Q6M9z4XnoDs7USwlVMfh/zz
	 EWyCnq1YY26ndpEJuqi0Pk1l69OUB5pVLAgaf89JnWC8+vJix0z+J1wknbL86gMU0GFvt
	 Z8MFafErkeE1OPbTIvsEecJTMvgmmduxXZEjqaYG2aAFtvFv2S5mpCjryO8ui3psek8h0
	 r2AEUaMKVm07MD1EahdZlkTFfPLiS1dv3nWhPKo9zLNt9xXfCQ8JhI+gv6Kmh3Mm03xVC
	 q2WllczBDDQH1Bv2HaVqAKNLBerBJJoUXFnENB8POT2Sa8LfUY9HrUFEmZfmC7Ra5Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184472;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=sqWf0ZqjfW7jYj0FTgNGieSVB4q6BkczPYaUBzocbio=;
	b=gQ+p9oGr9MXLFj+9kv0LwKBvEsPZFJGfw2sdxo7D+16knXDGHKfOXZAiQxU7ixkGcSsb
	 cq+d7SCvrbwSYtWI6HSjAr9JBfnf5WfS575TcSXDdi7iCjDpPPWoEmr+7eZb68vQ0Ij9Z
	 qvq9uE7i9ypfvdGfOFEhvNs6KNrgPCLeu79PDvc9H9pUdKanDaMSJCzkqX3XZd34q8Ar5
	 J1o6F2N0k2NeQ6fYuTYLV8q0WDdD4EFQ0yjI4H+91IVxt+JjxJzrtMhhv2TPKFKqFNm23
	 bYn/zWrqFI+1vHCbWFeEUF/BjH0ahLLAuiiA0wpHU/IMtfSrPZhokNvLKk3O/CbbY5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WxbEJWOi;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB04606D837
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 00:34:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DB04606D837
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WxbEJWOi
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4afe2d546f9so5215925e9.3
        for <linux-scsi@vger.kernel.org>; Sun, 08 Nov 2026 16:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184471; x=1794789271; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sqWf0ZqjfW7jYj0FTgNGieSVB4q6BkczPYaUBzocbio=;
        b=WxbEJWOi9QdqpPLO6Ad59r7g0ryBxuqjlkvMlrQfNlNetGvjWt7UZRvYSw+EsMrTpW
         lC9Ie+ZhXXPAOXc/xUS/3xT7VZPYdyIrqbQ4f9+1R+vIuQl6Fyl9S79VIfv31Dbc/jGd
         vGp6btvqST0z/IyGK7MXpRl8Ji5Gqj0cFHFckWgLhahaHcURIkKvM/P6NzmrGrBItv3I
         3zj4CTFNQ6tD4YqUCDb2a3wuovRyO4zKtvVaIcNQHgt8RUQbgVx8yBYj/ZUGL8NsS9F6
         o/Nomd+IFGlBsQVBOxzy5yoHKZeSfZtvQwpc+6rScaPo/xpz5CxWsa8i3RZBbutcR8Iv
         R52A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184471; x=1794789271;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sqWf0ZqjfW7jYj0FTgNGieSVB4q6BkczPYaUBzocbio=;
        b=x/cGuFSyiVQVN3aLuJZZnueUfPFMc0hd6ZalHi90efzjnGwdwgNhaIbgx+FPNqc38i
         k7Up9L+i3J4M4uqLjtLfqQSWunGPdvIXU9AJWuaCk4jCQ2AGN+ulUfqaezxiNf7f65Im
         H25OLiek7HKxOz+4ShXle8LELT8dz5UhAXiW8qgOHDLUAm5NgQoLrdbHafvTbMDDwHPO
         ZgsPASo1AWHtRlvv8Q0cwwp3i/y36ciJltFgANdk3X3IBYtnuHnKyqla4PBAUOW80fiY
         rW4iYNN92UU4eifPJ+xkFVGMkPnzc0M+k9MRWDNUjlKPgr+J02KuZCV381bckgKB0unV
         F4ug==
X-Forwarded-Encrypted: i=1; AL+hErFNDXDG5QF2T/Ubhv6/IhGR5vSo5EMsGZANrjZTdeeRjPavQHt+tXSorez99hS2lMU3mfnPyJ4p+HVq@vger.kernel.org
X-Gm-Message-State: APuU4Z/GaSndyJ9OQzGhqiYGUhRx8+7skqxNN8cEb/1AQ/CbgFFHv66H
	g093ob7hwxrE1yIPKlrTbXYj5tMFHoQWtabtyvH44dewgWDZGj2z33+wSpwIYlAGd+4=
X-Gm-Gg: AYBFou2F73y47m9QhwaK2BNDcnEJEcBgGjFw4Ireabbk4/BaD0b77M5biRz7OOIE6rJ
	ZxMmIm7mbgEsHcdvjPrWxB4UpSDYZ1VpeNzdrUo7m5XRxk6KMjL/3faPMEnk+AK6ItHtBOE5VYv
	etpS6xuKGrbTGnZxZ1TuUaz+Hh/jXwVdWPHInig2l162XnyCV6FSyIqpA1/HcbGzhehqCFvdelT
	gimLjLeYozezzju1a/X2TynORLbr0JaI6qZwxoWMMUyo33PoK9awT4Y2nM7V464K+f4jDWU80/V
	u4texsWO7vyXjAL233VWXkRogf7YWyTOGrmN4rTXoTD2EY+U8ZAbBNY3Ka5CA7tRwvO8WoOpS6x
	zMlCtbSILmuG2kPE/BjBoEjd39Ai3zyIT9LRqTtCcJGbhtwevLWY/wGcrvzvN6RLaO0uOx0FVrM
	D2q4idF7cjjXtGdmU6SNqeOdAo2z8IM/637raVyhFWK9umKeQbbIPtjCfpN2bClIcMky3jX4M2a
	hr6LORSInQzA3RYYwzDq3ETeT8C8Efu9a4d+DkSQLTUIui5933WNTxZms2eYk9/fWJLZAd6KsYh
	TkaGq/28i+UQ600k/0TB8GDCBs8Vhd3G88UZQ4e/
X-Received: by 2002:a05:600c:46d2:b0:4a1:df52:3e36 with SMTP id 5b1f17b1804b1-4b963c814b4mr45217895e9.27.1794184470772;
        Sun, 08 Nov 2026 16:34:30 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:34:29 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:24 +0000
Subject: [PATCH 12/17] dt-bindings: cpufreq: qcom-hw: Document Halliday
 CPUFREQ hardware
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-halliday-dts-v1-12-289114ab8197@gmail.com>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
In-Reply-To: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Guru Das Srinagesh <linux@gurudas.dev>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, Lee Jones <lee@kernel.org>, 
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
 "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Wesley Cheng <wesley.cheng@oss.qualcomm.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Amit Kucheria <amitk@kernel.org>, 
 Thara Gopinath <thara.gopinath@gmail.com>, 
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
 Lukasz Luba <lukasz.luba@arm.com>, Georgi Djakov <djakov@kernel.org>, 
 Sibi Sankar <sibi.sankar@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, mfd@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
 linux-usb@vger.kernel.org, linux-phy@lists.infradead.org, 
 linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-pm@vger.kernel.org, Stanislav Aleksandrov <lightofmysoul@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=1136;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=/5q7xJNdAtVYNP2eKqnOFRxkwGs69ZAxtJgwpCpPYPc=;
 b=gh19qIBvqo941uuBuTtSY86YfaNCAEdG9vJI0o/4tLOqHDCaja10/kLnOnTQrwdqkmy4TCdF6
 7e+ZDYLm+CcCb5BN2fAjGQTjhEqtQqzl3jdn43oLAWX5E1v6iUbyst4
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the CPUFREQ hardware (EPSS) on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml b/Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml
index 98eb36bff172..d6040cd293f9 100644
--- a/Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml
+++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml
@@ -36,6 +36,7 @@ properties:
         items:
           - enum:
               - qcom,eliza-cpufreq-epss
+              - qcom,halliday-cpufreq-epss
               - qcom,milos-cpufreq-epss
               - qcom,qcs8300-cpufreq-epss
               - qcom,qdu1000-cpufreq-epss
@@ -135,6 +136,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - qcom,halliday-cpufreq-epss
               - qcom,qcs615-cpufreq-hw
               - qcom,qdu1000-cpufreq-epss
               - qcom,sa8255p-cpufreq-epss

-- 
2.55.0

