Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184422;
	b=UfN9D++WQvTa6MwUIm2z3i2Yn5z5XRS58uiX68U2oByHDMuqsXs8Xz+uCvr35cZutafl
	 COflH5MKry4JV5MvocqEKG6amrgl6fnezzs3EuncrMBe1k3C1Hks0zOaCEqvlx1gfvEGm
	 O4s707uugPZH9YxZ+FrMOoiHl88qZrNYPmClQLwUZTFL6dF1GIgE7V8s+bNwyuhuyW7Z9
	 3O2A2uUCR20jRV+M0lhzeRfwLHxGwYkDY4ozCVWadlViLfbK10I2IJk7MjaQ554egiHzU
	 ZIXZDtdIw9UxegjeQqz2foJeFrXMyJwit5J9ZXoQ5pqg8rFE+3tWvuABpSH0rQdXerg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184422;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=r6Z+1pNGTBfmPrEnFxF8VVutZ1rF2maRRdQm8+3OOLA=;
	b=tyH8cvQQfzgHgIO3H+WYgqxbjSwbFSJRLwx/1I8C4yA7y42UcdJGTYAzbhS707NyPe5/
	 z3UakwToBvFkIUbxDRyZo9Zp+Ra+OrwT3gUwrnBv8/Zfur8VKAY40d+Mp+jHN/laL3+Lz
	 Tf+L/Sosko0bNIGkIv0wggS6rYOyU3pjgYADariFtg9Pe02sNttT2fIaWvldOYiwLZPHL
	 nYiyYX5DLfOtla04rMSHUCnQxLyxLREed6rSMOThrv4SM0fe0nSanLecUSkgGgW84p/bU
	 0yBJRKWWQONGH5/Idx+UeSki52RHKeT2TFxc6LmawJYwZLvI0ZCctENMYXWveVBf6dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="uD/fC9fw";
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE9E606D818
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 00:33:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBE9E606D818
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uD/fC9fw
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so3157725e9.3
        for <linux-scsi@vger.kernel.org>; Sun, 08 Nov 2026 16:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184420; x=1794789220; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r6Z+1pNGTBfmPrEnFxF8VVutZ1rF2maRRdQm8+3OOLA=;
        b=uD/fC9fwd35e4pRCBo6Ir49OZrB2lX+E5PGdQnHcUkYxiqu2ZiGRETZ2zJmW8sZlTd
         A5/c2Xw6hipV3YiwOTPc6CN0uAO33PQjgwXUPiZreZzu4FdcrszHSfLcFtjRZOPT3itQ
         xle2xxFDmZmDqyMCWSs93UsfOpeLxSN6ue7xOrrEm/NzYT0xzZK/eCHB+h5f9jiXpkxi
         ypgX50w+AjK0hyhr8W1Y5z3Zeklf121xyaUU04Mnsch0HJVE6Dc9AjOAXq0dywq2opUJ
         SUXNk4QGfcfXnyUDSGqSEEHPKlnphwjmf7JR4/7BbHKuz3djlAWOEVbyJKz8FiaAylH2
         4tDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184420; x=1794789220;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r6Z+1pNGTBfmPrEnFxF8VVutZ1rF2maRRdQm8+3OOLA=;
        b=zx8QNHXfwVKQYNL8rFhovbk2mAmJaG685aYqW6W+/+P018veaoFg/YvW1HyfMDL5Ni
         xAK8FvK5YafWilHil6JwC/8/s0b78kfAc2gi8gx5xhkB4ph/wRWfkLCIPHv9v8+2RiUL
         zcZxxFQWmWN6fuNrDh8iNgScQ7nCUL5WDpfAjtrDDYSaGkgOFKs00C5fgp7Et3u6JiZ+
         qCmOEfr1GO5dI3fXZb0cgUY+00oy8HwGV96cNJtYplQdi4Mc2tG1IbnIeGavqlGqj90S
         yMQiPAXmJ4F2To42i94+Y68DpjuQTt68dMQG63oo/Ad3D7iIjh8Dprjn6xgy2c1YwYQ7
         Ng/A==
X-Forwarded-Encrypted: i=1; AL+hErEGH0X+zmRH5R0bwm5Pd5O1PSOdQAnCbN+7lHQALaoYSRhbcdAVn3pNeIoiotRXqmzGM4gtrHvs8UKR@vger.kernel.org
X-Gm-Message-State: APuU4Z9cShrR/Q+vgrCpKjUp9pLL4qaplBxILzJEB/+2iUD4wasRQhAF
	TaS1l/wVknZjZ2pto5zbxJC8aqtvVfNDtYNfIZnw27hogtL9Qz+mg0SXQwyjR4UExCE=
X-Gm-Gg: AYBFou0wVbIHYvRN0t/sRfTDF+c7ovo7aH48X0UUevlPBEbSBfs+NiQrWDuUsqAROJq
	Qd97EJ846VsgztiUq+5aM4jEQ7jki54TS91z9sM5nH8aMh2NVyxgqWNcbKO3L1OByy8A4e+swtT
	eWMP/jkumzNg1y5d4YDWvRcsHI3vqbMOhllIv5Vti31yf8Xs9K8K7tTz5hiX31p/Mqhvkno9QIu
	aqHb0Q8+Y2CcSluk5qfIr4+cIxxsKL6a1vUsSOmYbBTvNEsl2AlYzXKg1Q8hnJRTMu2l54LPBPC
	wTBckDHROugsC92x7iVPqzkTu+4CPxbzbWfs+xSsznlAF3qsCXZvxce7V5vxtjP1tlhFwClGNhl
	/UxZtKTUYLXvg5N8pfG3rlQRCcMpPANhbWNr4kC2XUaN2IfhcnruBJ4JLRGD0r1ebEV9mOoVziz
	DFlq+1mVF9eKtYf+BN1k8Vx3N7bc8uVKn/VenW1Ot+7vO1YYr6FTS3TT6eMVMeU9pIe8Hwxor3X
	F+QhaVOi1ofpDxxkJO8ZYkGGwehpspdw4WjakR1mL8I93rByTAxH4sOx/TMROg/hScVAzDhorL4
	ESIM72moJ1yFvbVc/PE6LmsF8QX7B7hDx/3X9HrhUJ/KBnhkPjolxRfrP2TGuA==
X-Received: by 2002:a05:600c:5253:b0:4a2:a3b:7aa8 with SMTP id 5b1f17b1804b1-4b94d762eb6mr47593435e9.3.1794184420329;
        Sun, 08 Nov 2026 16:33:40 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:33:38 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:15 +0000
Subject: [PATCH 03/17] dt-bindings: interrupt-controller: qcom,pdc:
 Document Halliday PDC
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
Message-Id: <20261109-halliday-dts-v1-3-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=840;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=4hUtXzlXhIrBYYJFfDKQPQ3vEIzggE85cdjdS9WjQ78=;
 b=/Hr74fQlfTdpftwl6fj+vsUmb0ZD+laYeVxlhFK0akfSM/Zr+bIuUmQJNpniQW71Vw0S+OnBe
 X7HjWxQRJOhA4SO/MxeQgQ2JNwAjEDgqTYH/3IGyH4DzNXVVHXtyQib
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Power Domain Controller on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml b/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
index 8401d3b48e0f..cf20041e86c8 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
@@ -28,6 +28,7 @@ properties:
       - enum:
           - qcom,eliza-pdc
           - qcom,glymur-pdc
+          - qcom,halliday-pdc
           - qcom,hawi-pdc
           - qcom,kaanapali-pdc
           - qcom,kuno-pdc

-- 
2.55.0

