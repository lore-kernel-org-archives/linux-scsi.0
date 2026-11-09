Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184497;
	b=Q7BSISgaAfURAijhXgj3TqCKNvBZPZLmClXeDSQgVptgTZ/D/tujJp6mI3J/783eRRyz
	 AB49jM5FMngXUiwa5Of32g8iZZGVBuOpkoyBqQNGtdv0UaefAjtgbkvjlobuwobYO5PyB
	 u+/yaOGoO6atRaagBm7KA82nN8uAOkAo0nz/C1rjiye5duONCam71zKQ8w7H4sq9q0yMR
	 o4l1cNglIPHLQU7qtUdBATMKtVMLH+w8uyAsLlpOODELzegUwtrHRKcckEbjxzvHXBCWd
	 Z6IrCk37hwm9F+05k+S4gHPhKWqNhujGm3+9GkJqtLZgHSRdQXEXLhuM5TrfKqOb3/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184497;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=n9FBpaEZhwrwOQaRAEH1mwTmz+5FuR6jnB7psvsfM4w=;
	b=rUHx78Wdyco2sXo9+uw71YfzHfVvb/DnpeYn4RO+2UxpR7+BnfJvLFjXJtRQksLXxJ8s
	 bIsyyxjnJcwX2gI+QJYNM2z4BxrYtapsKo2Mdt3wbeycqKmoOLkFvDZWyWtMQXbTyu6lw
	 OcwFigS/lJHX4A0el4f3oJ6c29u6lv36kQYZ0SVpphHBGpq67ssS2OwsIgEQRWmctEUaP
	 PWHUPMzmRpHrHir+9EYe867W69VACpsAztldpWz2tG3n4UrPvhJqgF3xmyCR9A4EWtS+q
	 RHRNf6Qq+csgyi4BFB9aJM7PbyzQGEx/uYAvlG2utvFkv7Xeo4VfugvOuQuMyvAl3qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="bFje/2CL";
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650BE60A5BC8
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 00:34:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 650BE60A5BC8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bFje/2CL
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48e4831c028so390676f8f.0
        for <linux-scsi@vger.kernel.org>; Sun, 08 Nov 2026 16:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184495; x=1794789295; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n9FBpaEZhwrwOQaRAEH1mwTmz+5FuR6jnB7psvsfM4w=;
        b=bFje/2CL32SZtvLQ80eOCTs8ZyTaiR7c3V8OfLtwaWOsZ6b21QTazBBCSF2sHtMR4E
         Cz45PdU44hILeQhshFy64J3LKVbz6juGF80FB+AZeayNlhYJDQdhxvYkHFjVYNRhtmMP
         +CX0tL6H6sS8aX2N6I+GRQh11up4lis3hxFTmQzTiOEYZ8lYVfW8yITMSfXKehLHtX1j
         qFa/YOijw+edUBTJLgJDAOhzd83gfyapY+//zeYWyS7Q+RFgqwZ3KvITqKlDAKpm0drI
         w7bnpHEPvG3BPIZ8+RqVKFUk22udZrSuybA5lwOg7dfjNN/FMiihl893TUS/dXYV+sA0
         0ZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184495; x=1794789295;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n9FBpaEZhwrwOQaRAEH1mwTmz+5FuR6jnB7psvsfM4w=;
        b=2KhkHyE58Wd/ec4DPhFOoyoZnotD2xMi8dsxfWvOk+6sC+5dp63zW64BKiLQnJbojo
         WBNapXJoJ0Kk4/+vcEHH4nP4Eu/JJszyLj0KBBnLLRpGq8zvaqlkkoATIeBmZZAMszNa
         DSIQ4hDuxfVkUQWJhZtjyQHheJM9uEQ61QLsLBjXJl1wQ6EFLEKCdE8kN9I98zk3Btd2
         q0QX8yhFruY6s4O0f/xXd+DaMzwVnSradlDK0KMO3QFsVKNYoJwAqSjM2csdKaADlz6L
         UEIo4ttO06n6wjKtHBgqb2JhfbM+cLL7QCr1DF1vXlA7WkCgDua9KVYibZzuyLHi2Ree
         xSXw==
X-Forwarded-Encrypted: i=1; AL+hErFxd5X+jmVQzfUT20EnzeX0VJwApOfSvjcmcbr82QedwANGXOwLbgMF6wR8XEHJmDpz9JipxNdIMD1T@vger.kernel.org
X-Gm-Message-State: APuU4Z/i+GwBTmi4whuHOtpSQUryeu2s6X6A90u8vWIs+kB8P00NjI+Z
	vipMm27BFyrhFPDWIzhGQ+rdjfAmq0fXtMlhnVyG536aRIcZ6isfUUqPeNc4x6TPqmM=
X-Gm-Gg: AYBFou1x4srfaQ4YnA3pPO2759q7Q/Ip6qnne27RsV1roVTnXV1lbEnW1u50TeUA1Aa
	g3gpAf5k+WJF6oUkjy37RVgoeI0ol0R+/eqg+P0XkDGad/id+t4b9rGNuI/ZDfsEIF2gw7USi75
	mG/gBZZN5oPVyavQLl0CfSrf1YL3uOoWCYt8F5Vb7TozC1RtYfBgBqDnCoSMzL7dlXhf4zG++jm
	YFJlMbnCupsJKxsNnUfMaf6wxJQ2lCXrNeGZ9eI3Y/XzgI90cOJlZ9PJsdSaTnQOdX1wyZkfkps
	5LRw4FI/Qx6PsSs7NBfLAxQw5wiO04ZyFksiFd/O2c7j0pl20YrSwBQXvC7l5GFJsAIV/Yhwarx
	VxCC+chtZPQlO7xudAY251JEpBuHChUkzJDTTbTxlh2RQ256oSSvy8WQmtBY4YzGDVJgFPuTBWf
	rzFX1PtfWEzyEPBZfGp5g7pDVrJCDn+0HH0WeNUkt/A/L81nHOKt2Gw3OeBuCEoJcdGT3JUzD6j
	L4L8KuYBk5qDr4r6aISSoxXPgmvwu9XseClhZGcpSioWaSM3McKeaOEBLU2pd6p8w+t0NW0GfoW
	543hz6HfFF7hn+QPef/u5GrT7EEybdNbahi6TIlY
X-Received: by 2002:a05:6000:4a06:b0:492:820d:107e with SMTP id ffacd0b85a97d-49585bada1cmr4302773f8f.47.1794184494661;
        Sun, 08 Nov 2026 16:34:54 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:34:54 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:28 +0000
Subject: [PATCH 16/17] arm64: dts: qcom: Add initial Halliday dtsi
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
Message-Id: <20261109-halliday-dts-v1-16-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=47937;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=iblwrbZTceQvq2dUaQotN2fPtEL607onDYaXQ995afQ=;
 b=4q3Rp2rU5Ti21/X0B3Xl5csU36ns9IpqqubupZ3MWIzzV/Q3FK6V+EybXLBq4BAHcWerAO/kw
 AGKq74gsxojAny/9Ja6xV47eBy6VW1gECtbdMLowHE/TBZ3JIIgqbrd
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Add the device tree for the Qualcomm Halliday SoC
(SXR2250P / Snapdragon XR2+ Gen 2).

It describes the CPUs with their idle states, cpufreq and OPP tables,
the GIC and the PDC, the timers, SCM, SMEM, RPMh with its clocks, power
domains and interconnects, TLMM, GCC, SPMI, the apps SMMU, USB, UFS
with ICE, TSENS with the thermal zones and the PMU.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 arch/arm64/boot/dts/qcom/halliday.dtsi | 1859 ++++++++++++++++++++++++++++++++
 1 file changed, 1859 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/halliday.dtsi b/arch/arm64/boot/dts/qcom/halliday.dtsi
new file mode 100644
index 000000000000..c891913e3cc1
--- /dev/null
+++ b/arch/arm64/boot/dts/qcom/halliday.dtsi
@@ -0,0 +1,1859 @@
+// SPDX-License-Identifier: BSD-3-Clause
+/*
+ * Copyright (c) 2026, Stanislav Aleksandrov <lightofmysoul@gmail.com>
+ */
+
+#include <dt-bindings/clock/qcom,halliday-gcc.h>
+#include <dt-bindings/clock/qcom,rpmh.h>
+#include <dt-bindings/interconnect/qcom,halliday-rpmh.h>
+#include <dt-bindings/interconnect/qcom,icc.h>
+#include <dt-bindings/interconnect/qcom,osm-l3.h>
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/power/qcom,rpmhpd.h>
+#include <dt-bindings/soc/qcom,rpmh-rsc.h>
+
+/ {
+	interrupt-parent = <&intc>;
+
+	#address-cells = <2>;
+	#size-cells = <2>;
+
+	chosen {
+	};
+
+	clocks {
+		sleep_clk: sleep-clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+		};
+
+		xo_board: xo-board {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+		};
+	};
+
+	cpus {
+		#address-cells = <2>;
+		#size-cells = <0>;
+
+		cpu0: cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a78c";
+			reg = <0 0>;
+			clocks = <&cpufreq_hw 0>;
+			enable-method = "psci";
+			next-level-cache = <&l2_0>;
+			power-domains = <&cpu_pd0>;
+			power-domain-names = "psci";
+			capacity-dmips-mhz = <1024>;
+			dynamic-power-coefficient = <100>;
+			operating-points-v2 = <&cpu0_opp_table>;
+			interconnects = <&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &gem_noc SLAVE_LLCC QCOM_ICC_TAG_ACTIVE_ONLY>,
+					<&mc_virt MASTER_LLCC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ACTIVE_ONLY>,
+					<&epss_l3 MASTER_EPSS_L3_APPS
+					 &epss_l3 SLAVE_EPSS_L3_SHARED>;
+			#cooling-cells = <2>;
+			qcom,freq-domain = <&cpufreq_hw 0>;
+
+			l2_0: l2-cache {
+				compatible = "cache";
+				cache-level = <2>;
+				cache-unified;
+				next-level-cache = <&l3_0>;
+
+				l3_0: l3-cache {
+					compatible = "cache";
+					cache-level = <3>;
+					cache-unified;
+				};
+			};
+		};
+
+		cpu1: cpu@100 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a78c";
+			reg = <0 0x100>;
+			clocks = <&cpufreq_hw 0>;
+			enable-method = "psci";
+			next-level-cache = <&l2_100>;
+			power-domains = <&cpu_pd1>;
+			power-domain-names = "psci";
+			capacity-dmips-mhz = <1024>;
+			dynamic-power-coefficient = <100>;
+			operating-points-v2 = <&cpu0_opp_table>;
+			interconnects = <&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &gem_noc SLAVE_LLCC QCOM_ICC_TAG_ACTIVE_ONLY>,
+					<&mc_virt MASTER_LLCC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ACTIVE_ONLY>,
+					<&epss_l3 MASTER_EPSS_L3_APPS
+					 &epss_l3 SLAVE_EPSS_L3_SHARED>;
+			#cooling-cells = <2>;
+			qcom,freq-domain = <&cpufreq_hw 0>;
+
+			l2_100: l2-cache {
+				compatible = "cache";
+				cache-level = <2>;
+				cache-unified;
+				next-level-cache = <&l3_0>;
+			};
+		};
+
+		cpu2: cpu@200 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a78c";
+			reg = <0 0x200>;
+			clocks = <&cpufreq_hw 1>;
+			enable-method = "psci";
+			next-level-cache = <&l2_200>;
+			power-domains = <&cpu_pd2>;
+			power-domain-names = "psci";
+			capacity-dmips-mhz = <1075>;
+			dynamic-power-coefficient = <85>;
+			operating-points-v2 = <&cpu2_opp_table>;
+			interconnects = <&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &gem_noc SLAVE_LLCC QCOM_ICC_TAG_ACTIVE_ONLY>,
+					<&mc_virt MASTER_LLCC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ACTIVE_ONLY>,
+					<&epss_l3 MASTER_EPSS_L3_APPS
+					 &epss_l3 SLAVE_EPSS_L3_SHARED>;
+			#cooling-cells = <2>;
+			qcom,freq-domain = <&cpufreq_hw 1>;
+
+			l2_200: l2-cache {
+				compatible = "cache";
+				cache-level = <2>;
+				cache-unified;
+				next-level-cache = <&l3_0>;
+			};
+		};
+
+		cpu3: cpu@300 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a78c";
+			reg = <0 0x300>;
+			clocks = <&cpufreq_hw 1>;
+			enable-method = "psci";
+			next-level-cache = <&l2_300>;
+			power-domains = <&cpu_pd3>;
+			power-domain-names = "psci";
+			capacity-dmips-mhz = <1075>;
+			dynamic-power-coefficient = <85>;
+			operating-points-v2 = <&cpu2_opp_table>;
+			interconnects = <&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &gem_noc SLAVE_LLCC QCOM_ICC_TAG_ACTIVE_ONLY>,
+					<&mc_virt MASTER_LLCC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ACTIVE_ONLY>,
+					<&epss_l3 MASTER_EPSS_L3_APPS
+					 &epss_l3 SLAVE_EPSS_L3_SHARED>;
+			#cooling-cells = <2>;
+			qcom,freq-domain = <&cpufreq_hw 1>;
+
+			l2_300: l2-cache {
+				compatible = "cache";
+				cache-level = <2>;
+				cache-unified;
+				next-level-cache = <&l3_0>;
+			};
+		};
+
+		cpu4: cpu@400 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a78c";
+			reg = <0 0x400>;
+			clocks = <&cpufreq_hw 1>;
+			enable-method = "psci";
+			next-level-cache = <&l2_400>;
+			power-domains = <&cpu_pd4>;
+			power-domain-names = "psci";
+			capacity-dmips-mhz = <1075>;
+			dynamic-power-coefficient = <85>;
+			operating-points-v2 = <&cpu2_opp_table>;
+			interconnects = <&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &gem_noc SLAVE_LLCC QCOM_ICC_TAG_ACTIVE_ONLY>,
+					<&mc_virt MASTER_LLCC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ACTIVE_ONLY>,
+					<&epss_l3 MASTER_EPSS_L3_APPS
+					 &epss_l3 SLAVE_EPSS_L3_SHARED>;
+			#cooling-cells = <2>;
+			qcom,freq-domain = <&cpufreq_hw 1>;
+
+			l2_400: l2-cache {
+				compatible = "cache";
+				cache-level = <2>;
+				cache-unified;
+				next-level-cache = <&l3_0>;
+			};
+		};
+
+		cpu5: cpu@500 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a78c";
+			reg = <0 0x500>;
+			clocks = <&cpufreq_hw 1>;
+			enable-method = "psci";
+			next-level-cache = <&l2_500>;
+			power-domains = <&cpu_pd5>;
+			power-domain-names = "psci";
+			capacity-dmips-mhz = <1075>;
+			dynamic-power-coefficient = <85>;
+			operating-points-v2 = <&cpu2_opp_table>;
+			interconnects = <&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &gem_noc SLAVE_LLCC QCOM_ICC_TAG_ACTIVE_ONLY>,
+					<&mc_virt MASTER_LLCC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ACTIVE_ONLY>,
+					<&epss_l3 MASTER_EPSS_L3_APPS
+					 &epss_l3 SLAVE_EPSS_L3_SHARED>;
+			#cooling-cells = <2>;
+			qcom,freq-domain = <&cpufreq_hw 1>;
+
+			l2_500: l2-cache {
+				compatible = "cache";
+				cache-level = <2>;
+				cache-unified;
+				next-level-cache = <&l3_0>;
+			};
+		};
+
+		cpu-map {
+			cluster0 {
+				core0 {
+					cpu = <&cpu0>;
+				};
+
+				core1 {
+					cpu = <&cpu1>;
+				};
+
+				core2 {
+					cpu = <&cpu2>;
+				};
+
+				core3 {
+					cpu = <&cpu3>;
+				};
+
+				core4 {
+					cpu = <&cpu4>;
+				};
+
+				core5 {
+					cpu = <&cpu5>;
+				};
+			};
+		};
+
+		domain-idle-states {
+			cluster_sleep_0: cluster-sleep-0 {
+				compatible = "domain-idle-state";
+				entry-latency-us = <1050>;
+				exit-latency-us = <2500>;
+				min-residency-us = <9309>;
+				arm,psci-suspend-param = <0x41000044>;
+			};
+
+			cluster_sleep_1: cluster-sleep-1 {
+				compatible = "domain-idle-state";
+				entry-latency-us = <2700>;
+				exit-latency-us = <3500>;
+				min-residency-us = <13959>;
+				arm,psci-suspend-param = <0x4100c344>;
+			};
+		};
+
+		idle-states {
+			entry-method = "psci";
+
+			gold_cpu_sleep_0: cpu-sleep-0-0 {
+				compatible = "arm,idle-state";
+				idle-state-name = "gold-power-collapse";
+				entry-latency-us = <400>;
+				exit-latency-us = <1400>;
+				min-residency-us = <2207>;
+				local-timer-stop;
+				arm,psci-suspend-param = <0x40000003>;
+			};
+
+			gold_cpu_sleep_1: cpu-sleep-0-1 {
+				compatible = "arm,idle-state";
+				idle-state-name = "gold-rail-power-collapse";
+				entry-latency-us = <600>;
+				exit-latency-us = <1300>;
+				min-residency-us = <8136>;
+				local-timer-stop;
+				arm,psci-suspend-param = <0x40000004>;
+			};
+
+			gold_plus_cpu_sleep_0: cpu-sleep-1-0 {
+				compatible = "arm,idle-state";
+				idle-state-name = "gold-plus-power-collapse";
+				entry-latency-us = <300>;
+				exit-latency-us = <1450>;
+				min-residency-us = <3230>;
+				local-timer-stop;
+				arm,psci-suspend-param = <0x40000003>;
+			};
+
+			gold_plus_cpu_sleep_1: cpu-sleep-1-1 {
+				compatible = "arm,idle-state";
+				idle-state-name = "gold-plus-rail-power-collapse";
+				entry-latency-us = <500>;
+				exit-latency-us = <1350>;
+				min-residency-us = <7480>;
+				local-timer-stop;
+				arm,psci-suspend-param = <0x40000004>;
+			};
+		};
+	};
+
+	firmware {
+		scm: scm {
+			compatible = "qcom,scm-halliday", "qcom,scm";
+			qcom,dload-mode = <&tcsr 0x13000>;
+			interconnects = <&aggre2_noc MASTER_CRYPTO QCOM_ICC_TAG_ALWAYS
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>;
+		};
+	};
+
+	clk_virt: interconnect-0 {
+		compatible = "qcom,halliday-clk-virt";
+		#interconnect-cells = <2>;
+		qcom,bcm-voters = <&apps_bcm_voter>;
+	};
+
+	mc_virt: interconnect-1 {
+		compatible = "qcom,halliday-mc-virt";
+		#interconnect-cells = <2>;
+		qcom,bcm-voters = <&apps_bcm_voter>;
+	};
+
+	memory@a0000000 {
+		device_type = "memory";
+		/* We expect the bootloader to fill in the size */
+		reg = <0 0xa0000000 0 0>;
+	};
+
+	cpu0_opp_table: opp-table-cpu0 {
+		compatible = "operating-points-v2";
+		opp-shared;
+
+		opp-691200000 {
+			opp-hz = /bits/ 64 <691200000>;
+			opp-peak-kBps = <(300000 * 16) (547000 * 4) (422400 * 32)>;
+		};
+
+		opp-960000000 {
+			opp-hz = /bits/ 64 <960000000>;
+			opp-peak-kBps = <(466500 * 16) (547000 * 4) (691200 * 32)>;
+		};
+
+		opp-1094400000 {
+			opp-hz = /bits/ 64 <1094400000>;
+			opp-peak-kBps = <(466500 * 16) (547000 * 4) (825600 * 32)>;
+		};
+
+		opp-1228800000 {
+			opp-hz = /bits/ 64 <1228800000>;
+			opp-peak-kBps = <(600000 * 16) (768000 * 4) (1075200 * 32)>;
+		};
+
+		opp-1382400000 {
+			opp-hz = /bits/ 64 <1382400000>;
+			opp-peak-kBps = <(600000 * 16) (1555000 * 4) (1209600 * 32)>;
+		};
+
+		opp-1516800000 {
+			opp-hz = /bits/ 64 <1516800000>;
+			opp-peak-kBps = <(600000 * 16) (2092000 * 4) (1401600 * 32)>;
+		};
+
+		opp-1651200000 {
+			opp-hz = /bits/ 64 <1651200000>;
+			opp-peak-kBps = <(806000 * 16) (2736000 * 4) (1612800 * 32)>;
+		};
+
+		opp-1920000000 {
+			opp-hz = /bits/ 64 <1920000000>;
+			opp-peak-kBps = <(806000 * 16) (3196000 * 4) (1708800 * 32)>;
+		};
+
+		opp-2054400000 {
+			opp-hz = /bits/ 64 <2054400000>;
+			opp-peak-kBps = <(1066000 * 16) (3196000 * 4) (1708800 * 32)>;
+		};
+
+		opp-2208000000 {
+			opp-hz = /bits/ 64 <2208000000>;
+			opp-peak-kBps = <(1066000 * 16) (3196000 * 4) (1708800 * 32)>;
+		};
+
+		opp-2361600000 {
+			opp-hz = /bits/ 64 <2361600000>;
+			opp-peak-kBps = <(1066000 * 16) (3196000 * 4) (1708800 * 32)>;
+		};
+	};
+
+	cpu2_opp_table: opp-table-cpu2 {
+		compatible = "operating-points-v2";
+		opp-shared;
+
+		opp-691200000 {
+			opp-hz = /bits/ 64 <691200000>;
+			opp-peak-kBps = <(300000 * 16) (547000 * 4) (422400 * 32)>;
+		};
+
+		opp-960000000 {
+			opp-hz = /bits/ 64 <960000000>;
+			opp-peak-kBps = <(466500 * 16) (547000 * 4) (691200 * 32)>;
+		};
+
+		opp-1094400000 {
+			opp-hz = /bits/ 64 <1094400000>;
+			opp-peak-kBps = <(466500 * 16) (547000 * 4) (825600 * 32)>;
+		};
+
+		opp-1228800000 {
+			opp-hz = /bits/ 64 <1228800000>;
+			opp-peak-kBps = <(600000 * 16) (768000 * 4) (1075200 * 32)>;
+		};
+
+		opp-1382400000 {
+			opp-hz = /bits/ 64 <1382400000>;
+			opp-peak-kBps = <(600000 * 16) (1555000 * 4) (1209600 * 32)>;
+		};
+
+		opp-1516800000 {
+			opp-hz = /bits/ 64 <1516800000>;
+			opp-peak-kBps = <(600000 * 16) (2092000 * 4) (1401600 * 32)>;
+		};
+
+		opp-1651200000 {
+			opp-hz = /bits/ 64 <1651200000>;
+			opp-peak-kBps = <(806000 * 16) (2736000 * 4) (1612800 * 32)>;
+		};
+
+		opp-1920000000 {
+			opp-hz = /bits/ 64 <1920000000>;
+			opp-peak-kBps = <(806000 * 16) (3196000 * 4) (1708800 * 32)>;
+		};
+
+		opp-2054400000 {
+			opp-hz = /bits/ 64 <2054400000>;
+			opp-peak-kBps = <(806000 * 16) (3196000 * 4) (1708800 * 32)>;
+		};
+
+		opp-2208000000 {
+			opp-hz = /bits/ 64 <2208000000>;
+			opp-peak-kBps = <(933000 * 16) (3196000 * 4) (1708800 * 32)>;
+		};
+
+		opp-2361600000 {
+			opp-hz = /bits/ 64 <2361600000>;
+			opp-peak-kBps = <(1066000 * 16) (3196000 * 4) (1708800 * 32)>;
+		};
+	};
+
+	pmu {
+		compatible = "arm,cortex-a78-pmu";
+		interrupts = <GIC_PPI 7 IRQ_TYPE_LEVEL_LOW>;
+	};
+
+	psci {
+		compatible = "arm,psci-1.0";
+		method = "smc";
+
+		cluster_pd: power-domain-cluster {
+			#power-domain-cells = <0>;
+			domain-idle-states = <&cluster_sleep_0>, <&cluster_sleep_1>;
+		};
+
+		cpu_pd0: power-domain-cpu0 {
+			#power-domain-cells = <0>;
+			power-domains = <&cluster_pd>;
+			domain-idle-states = <&gold_cpu_sleep_0>, <&gold_cpu_sleep_1>;
+		};
+
+		cpu_pd1: power-domain-cpu1 {
+			#power-domain-cells = <0>;
+			power-domains = <&cluster_pd>;
+			domain-idle-states = <&gold_cpu_sleep_0>, <&gold_cpu_sleep_1>;
+		};
+
+		cpu_pd2: power-domain-cpu2 {
+			#power-domain-cells = <0>;
+			power-domains = <&cluster_pd>;
+			domain-idle-states = <&gold_plus_cpu_sleep_0>, <&gold_plus_cpu_sleep_1>;
+		};
+
+		cpu_pd3: power-domain-cpu3 {
+			#power-domain-cells = <0>;
+			power-domains = <&cluster_pd>;
+			domain-idle-states = <&gold_plus_cpu_sleep_0>, <&gold_plus_cpu_sleep_1>;
+		};
+
+		cpu_pd4: power-domain-cpu4 {
+			#power-domain-cells = <0>;
+			power-domains = <&cluster_pd>;
+			domain-idle-states = <&gold_plus_cpu_sleep_0>, <&gold_plus_cpu_sleep_1>;
+		};
+
+		cpu_pd5: power-domain-cpu5 {
+			#power-domain-cells = <0>;
+			power-domains = <&cluster_pd>;
+			domain-idle-states = <&gold_plus_cpu_sleep_0>, <&gold_plus_cpu_sleep_1>;
+		};
+	};
+
+	reserved_memory: reserved-memory {
+		ranges;
+		#address-cells = <2>;
+		#size-cells = <2>;
+
+		hyp_qheebsp_mem: hyp-qheebsp-region@80000000 {
+			reg = <0 0x80000000 0 0x200000>;
+			no-map;
+		};
+
+		hyp_data_mem: hyp-data-region@80200000 {
+			reg = <0 0x80200000 0 0x400000>;
+			no-map;
+		};
+
+		hyp_rm_hypx_mem: hyp-rm-hypx-region@80600000 {
+			reg = <0 0x80600000 0 0x200000>;
+			no-map;
+		};
+
+		cpusys_vm_mem: cpusys-vm-region@80800000 {
+			reg = <0 0x80800000 0 0x400000>;
+			no-map;
+		};
+
+		hyp_heap_mem: hyp-heap-region@80c00000 {
+			reg = <0 0x80c00000 0 0x200000>;
+			no-map;
+		};
+
+		hyp_tags_mem: hyp-tags-region@80e00000 {
+			reg = <0 0x80e00000 0 0x3d0000>;
+			no-map;
+		};
+
+		xbl_dt_log_mem: xbl-dt-log-region@81a00000 {
+			reg = <0 0x81a00000 0 0x40000>;
+			no-map;
+		};
+
+		xbl_ramdump_mem: xbl-ramdump-region@81a40000 {
+			reg = <0 0x81a40000 0 0x1c0000>;
+			no-map;
+		};
+
+		aop_image_mem: aop-image-region@81c00000 {
+			reg = <0 0x81c00000 0 0x60000>;
+			no-map;
+		};
+
+		aop_cmd_db_mem: aop-cmd-db-region@81c60000 {
+			compatible = "qcom,cmd-db";
+			reg = <0 0x81c60000 0 0x20000>;
+			no-map;
+		};
+
+		aop_config_mem: aop-config-region@81c80000 {
+			reg = <0 0x81c80000 0 0x20000>;
+			no-map;
+		};
+
+		tme_crash_dump_mem: tme-crash-dump-region@81ca0000 {
+			reg = <0 0x81ca0000 0 0x40000>;
+			no-map;
+		};
+
+		tme_log_mem: tme-log-region@81ce0000 {
+			reg = <0 0x81ce0000 0 0x4000>;
+			no-map;
+		};
+
+		uefi_log_mem: uefi-log-region@81ce4000 {
+			reg = <0 0x81ce4000 0 0x10000>;
+			no-map;
+		};
+
+		chipinfo_mem: chipinfo-region@81cf4000 {
+			reg = <0 0x81cf4000 0 0x1000>;
+			no-map;
+		};
+
+		secdata_apss_mem: secdata-apss-region@81cff000 {
+			reg = <0 0x81cff000 0 0x1000>;
+			no-map;
+		};
+
+		smem_mem: smem@81d00000 {
+			compatible = "qcom,smem";
+			reg = <0 0x81d00000 0 0x200000>;
+			hwlocks = <&tcsr_mutex 3>;
+			no-map;
+		};
+
+		global_sync_mem: global-sync-region@82600000 {
+			reg = <0 0x82600000 0 0x100000>;
+			no-map;
+		};
+
+		tz_stat_mem: tz-stat-region@82700000 {
+			reg = <0 0x82700000 0 0x100000>;
+			no-map;
+		};
+
+		video_mem: video-region@88d00000 {
+			reg = <0 0x88d00000 0 0x700000>;
+			no-map;
+		};
+
+		adsp_mem: adsp-region@89400000 {
+			reg = <0 0x89400000 0 0x2100000>;
+			no-map;
+		};
+
+		cdsp_mem: cdsp-region@8b500000 {
+			reg = <0 0x8b500000 0 0xf00000>;
+			no-map;
+		};
+
+		ipa_fw_mem: ipa-fw-region@8d500000 {
+			reg = <0 0x8d500000 0 0x10000>;
+			no-map;
+		};
+
+		ipa_gsi_mem: ipa-gsi-region@8d510000 {
+			reg = <0 0x8d510000 0 0xa000>;
+			no-map;
+		};
+
+		gpu_microcode_mem: gpu-microcode-region@8d51a000 {
+			reg = <0 0x8d51a000 0 0x2000>;
+			no-map;
+		};
+
+		spss_mem: spss-region@8d600000 {
+			reg = <0 0x8d600000 0 0x180000>;
+			no-map;
+		};
+
+		spu_tz_shared_mem: spu-tz-shared-region@8d780000 {
+			reg = <0 0x8d780000 0 0x80000>;
+			no-map;
+		};
+
+		cvp_mem: cvp-region@8d800000 {
+			reg = <0 0x8d800000 0 0x700000>;
+			no-map;
+		};
+
+		camera_mem: camera-region@8df00000 {
+			reg = <0 0x8df00000 0 0x800000>;
+			no-map;
+		};
+
+		cpucp_fw_mem: cpucp-fw-region@d8000000 {
+			reg = <0 0xd8000000 0 0x100000>;
+			no-map;
+		};
+
+		xbl_sc_mem: xbl-sc-region@d8100000 {
+			reg = <0 0xd8100000 0 0x40000>;
+			no-map;
+		};
+
+		tz_reserved_mem: tz-reserved-region@d8140000 {
+			reg = <0 0xd8140000 0 0x1c0000>;
+			no-map;
+		};
+
+		qtee_mem: qtee-region@d8300000 {
+			reg = <0 0xd8300000 0 0x500000>;
+			no-map;
+		};
+
+		ta_mem: ta-region@d8800000 {
+			reg = <0 0xd8800000 0 0x3000000>;
+			no-map;
+		};
+
+		tz_tags_mem: tz-tags-region@db800000 {
+			reg = <0 0xdb800000 0 0xf00000>;
+			no-map;
+		};
+	};
+
+	soc: soc@0 {
+		compatible = "simple-bus";
+		ranges = <0 0 0 0 0x10 0>;
+		dma-ranges = <0 0 0 0 0x10 0>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+
+		gcc: clock-controller@100000 {
+			compatible = "qcom,halliday-gcc";
+			reg = <0 0x00100000 0 0x1f4200>;
+			clocks = <&rpmhcc RPMH_CXO_CLK>,
+				 <&sleep_clk>,
+				 <0>,
+				 <0>,
+				 <0>,
+				 <0>,
+				 <&ufs_mem_phy 0>,
+				 <&ufs_mem_phy 1>,
+				 <&ufs_mem_phy 2>,
+				 <0>;
+			power-domains = <&rpmhpd RPMHPD_CX>;
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+			#power-domain-cells = <1>;
+		};
+
+		config_noc: interconnect@1500000 {
+			compatible = "qcom,halliday-config-noc";
+			reg = <0 0x01500000 0 0x13080>;
+			#interconnect-cells = <2>;
+			qcom,bcm-voters = <&apps_bcm_voter>;
+		};
+
+		system_noc: interconnect@1680000 {
+			compatible = "qcom,halliday-system-noc";
+			reg = <0 0x01680000 0 0x13080>;
+			#interconnect-cells = <2>;
+			qcom,bcm-voters = <&apps_bcm_voter>;
+		};
+
+		pcie_anoc: interconnect@16c0000 {
+			compatible = "qcom,halliday-pcie-anoc";
+			reg = <0 0x016c0000 0 0xc080>;
+			clocks = <&gcc GCC_AGGRE_NOC_PCIE_AXI_CLK>,
+				 <&gcc GCC_CFG_NOC_PCIE_ANOC_AHB_CLK>,
+				 <&gcc GCC_AGGRE_NOC_PCIE_SF_AXI_CLK>;
+			#interconnect-cells = <2>;
+			qcom,bcm-voters = <&apps_bcm_voter>;
+		};
+
+		aggre1_noc: interconnect@16e0000 {
+			compatible = "qcom,halliday-aggre1-noc";
+			reg = <0 0x016e0000 0 0x9080>;
+			clocks = <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
+				 <&gcc GCC_AGGRE_USB3_PRIM_AXI_CLK>;
+			#interconnect-cells = <2>;
+			qcom,bcm-voters = <&apps_bcm_voter>;
+		};
+
+		aggre2_noc: interconnect@1700000 {
+			compatible = "qcom,halliday-aggre2-noc";
+			reg = <0 0x01700000 0 0x15080>;
+			clocks = <&rpmhcc RPMH_IPA_CLK>;
+			#interconnect-cells = <2>;
+			qcom,bcm-voters = <&apps_bcm_voter>;
+		};
+
+		mmss_noc: interconnect@1740000 {
+			compatible = "qcom,halliday-mmss-noc";
+			reg = <0 0x01740000 0 0x1c100>;
+			#interconnect-cells = <2>;
+			qcom,bcm-voters = <&apps_bcm_voter>;
+		};
+
+		ufs_mem_hc: ufshc@1d84000 {
+			compatible = "qcom,halliday-ufshc", "qcom,ufshc",
+				     "jedec,ufs-2.0";
+			reg = <0 0x01d84000 0 0x3000>;
+			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
+
+			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
+				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>,
+				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
+				 <&rpmhcc RPMH_CXO_CLK>,
+				 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
+				 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
+				 <&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
+			clock-names = "core_clk",
+				      "bus_aggr_clk",
+				      "iface_clk",
+				      "core_clk_unipro",
+				      "ref_clk",
+				      "tx_lane0_sync_clk",
+				      "rx_lane0_sync_clk",
+				      "rx_lane1_sync_clk";
+			operating-points-v2 = <&ufs_opp_table>;
+
+			resets = <&gcc GCC_UFS_PHY_BCR>;
+			reset-names = "rst";
+			#reset-cells = <1>;
+
+			interconnects = <&aggre1_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
+					<&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &config_noc SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ACTIVE_ONLY>;
+			interconnect-names = "ufs-ddr",
+					     "cpu-ufs";
+
+			power-domains = <&gcc UFS_PHY_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
+
+			iommus = <&apps_smmu 0x60 0x0>;
+			dma-coherent;
+
+			lanes-per-direction = <2>;
+			phys = <&ufs_mem_phy>;
+			phy-names = "ufsphy";
+
+			qcom,ice = <&ice>;
+
+			status = "disabled";
+
+			ufs_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-75000000 {
+					opp-hz = /bits/ 64 <75000000 0 0 75000000 0 0 0 0>;
+					required-opps = <&rpmhpd_opp_low_svs>;
+				};
+
+				opp-150000000 {
+					opp-hz = /bits/ 64 <150000000 0 0 150000000 0 0 0 0>;
+					required-opps = <&rpmhpd_opp_svs>;
+				};
+
+				opp-300000000 {
+					opp-hz = /bits/ 64 <300000000 0 0 300000000 0 0 0 0>;
+					required-opps = <&rpmhpd_opp_nom>;
+				};
+			};
+		};
+
+		ufs_mem_phy: phy@1d87000 {
+			compatible = "qcom,halliday-qmp-ufs-phy", "qcom,sm8450-qmp-ufs-phy";
+			reg = <0 0x01d87000 0 0x1000>;
+
+			clocks = <&rpmhcc RPMH_CXO_CLK>,
+				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
+				 <&gcc GCC_UFS_0_CLKREF_EN>;
+			clock-names = "ref",
+				      "ref_aux",
+				      "qref";
+
+			resets = <&ufs_mem_hc 0>;
+			reset-names = "ufsphy";
+
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
+			#clock-cells = <1>;
+			#phy-cells = <0>;
+
+			status = "disabled";
+		};
+
+		ice: crypto@1d88000 {
+			compatible = "qcom,halliday-inline-crypto-engine",
+				     "qcom,inline-crypto-engine";
+			reg = <0 0x01d88000 0 0x18000>;
+
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+
+			operating-points-v2 = <&ice_opp_table>;
+
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
+			ice_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-100000000 {
+					opp-hz = /bits/ 64 <100000000>;
+					required-opps = <&rpmhpd_opp_low_svs>;
+				};
+
+				opp-201500000 {
+					opp-hz = /bits/ 64 <201500000>;
+					required-opps = <&rpmhpd_opp_svs>;
+				};
+
+				opp-403000000 {
+					opp-hz = /bits/ 64 <403000000>;
+					required-opps = <&rpmhpd_opp_nom>;
+				};
+			};
+		};
+
+		tcsr_mutex: hwlock@1f40000 {
+			compatible = "qcom,tcsr-mutex";
+			reg = <0 0x01f40000 0 0x20000>;
+			#hwlock-cells = <1>;
+		};
+
+		tcsr: syscon@1fc0000 {
+			compatible = "qcom,halliday-tcsr", "syscon";
+			reg = <0 0x01fc0000 0 0x30000>;
+		};
+
+		lpass_ag_noc: interconnect@3c40000 {
+			compatible = "qcom,halliday-lpass-ag-noc";
+			reg = <0 0x03c40000 0 0x17200>;
+			#interconnect-cells = <2>;
+			qcom,bcm-voters = <&apps_bcm_voter>;
+		};
+
+		usb_1_hsphy: phy@88e3000 {
+			compatible = "qcom,halliday-usb-hs-phy",
+				     "qcom,usb-snps-hs-7nm-phy";
+			reg = <0 0x088e3000 0 0x400>;
+
+			clocks = <&gcc GCC_USB2_0_CLKREF_EN>;
+			clock-names = "ref";
+
+			resets = <&gcc GCC_QUSB2PHY_PRIM_BCR>;
+
+			#phy-cells = <0>;
+
+			status = "disabled";
+		};
+
+		usb_1: usb@a600000 {
+			compatible = "qcom,halliday-dwc3", "qcom,snps-dwc3";
+			reg = <0 0x0a600000 0 0xfc100>;
+
+			clocks = <&gcc GCC_CFG_NOC_USB3_PRIM_AXI_CLK>,
+				 <&gcc GCC_USB30_PRIM_MASTER_CLK>,
+				 <&gcc GCC_AGGRE_USB3_PRIM_AXI_CLK>,
+				 <&gcc GCC_USB30_PRIM_SLEEP_CLK>,
+				 <&gcc GCC_USB30_PRIM_MOCK_UTMI_CLK>;
+			clock-names = "cfg_noc",
+				      "core",
+				      "iface",
+				      "sleep",
+				      "mock_utmi";
+
+			assigned-clocks = <&gcc GCC_USB30_PRIM_MOCK_UTMI_CLK>,
+					  <&gcc GCC_USB30_PRIM_MASTER_CLK>;
+			assigned-clock-rates = <19200000>, <200000000>;
+
+			interrupts-extended = <&intc GIC_SPI 133 IRQ_TYPE_LEVEL_HIGH>,
+					      <&intc GIC_SPI 130 IRQ_TYPE_LEVEL_HIGH>,
+					      <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc 14 IRQ_TYPE_EDGE_BOTH>,
+					      <&pdc 15 IRQ_TYPE_EDGE_BOTH>,
+					      <&pdc 17 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "dwc_usb3",
+					  "pwr_event",
+					  "hs_phy_irq",
+					  "dp_hs_phy_irq",
+					  "dm_hs_phy_irq",
+					  "ss_phy_irq";
+
+			power-domains = <&gcc USB30_PRIM_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
+
+			resets = <&gcc GCC_USB30_PRIM_BCR>;
+
+			iommus = <&apps_smmu 0x40 0x0>;
+			dma-coherent;
+
+			interconnects = <&aggre1_noc MASTER_USB3_0 QCOM_ICC_TAG_ALWAYS
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
+					<&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &config_noc SLAVE_USB3_0 QCOM_ICC_TAG_ACTIVE_ONLY>;
+			interconnect-names = "usb-ddr",
+					     "apps-usb";
+
+			phys = <&usb_1_hsphy>;
+			phy-names = "usb2-phy";
+
+			snps,dis_u2_susphy_quirk;
+			snps,dis_u3_susphy_quirk;
+			snps,dis_enblslpm_quirk;
+			snps,dis-u1-entry-quirk;
+			snps,dis-u2-entry-quirk;
+
+			status = "disabled";
+		};
+
+		pdc: interrupt-controller@b220000 {
+			compatible = "qcom,halliday-pdc", "qcom,pdc";
+			reg = <0 0x0b220000 0 0x30000>,
+			      <0 0x174000f0 0 0x64>;
+			#interrupt-cells = <2>;
+			interrupt-parent = <&intc>;
+			interrupt-controller;
+			qcom,pdc-ranges = <0 480 94>,
+					  <94 609 31>,
+					  <125 63 1>,
+					  <126 716 12>;
+		};
+
+		tsens0: thermal-sensor@c263000 {
+			compatible = "qcom,halliday-tsens", "qcom,tsens-v2";
+			reg = <0 0x0c263000 0 0x1000>,
+			      <0 0x0c222000 0 0x1000>;
+			interrupts = <GIC_SPI 506 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 508 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "uplow", "critical";
+			#thermal-sensor-cells = <1>;
+			#qcom,sensors = <16>;
+		};
+
+		tsens1: thermal-sensor@c265000 {
+			compatible = "qcom,halliday-tsens", "qcom,tsens-v2";
+			reg = <0 0x0c265000 0 0x1000>,
+			      <0 0x0c223000 0 0x1000>;
+			interrupts = <GIC_SPI 507 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 509 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "uplow", "critical";
+			#thermal-sensor-cells = <1>;
+			#qcom,sensors = <15>;
+		};
+
+		spmi_bus: spmi@c400000 {
+			compatible = "qcom,spmi-pmic-arb";
+			reg = <0 0x0c400000 0 0x3000>,
+			      <0 0x0c500000 0 0x400000>,
+			      <0 0x0c440000 0 0x80000>,
+			      <0 0x0c4c0000 0 0x20000>,
+			      <0 0x0c42d000 0 0x4000>;
+			reg-names = "core", "chnls", "obsrvr", "intr", "cnfg";
+			interrupt-names = "periph_irq";
+			interrupts-extended = <&pdc 1 IRQ_TYPE_LEVEL_HIGH>;
+			#address-cells = <2>;
+			#size-cells = <0>;
+			interrupt-controller;
+			#interrupt-cells = <4>;
+			qcom,ee = <0>;
+			qcom,channel = <0>;
+		};
+
+		tlmm: pinctrl@f100000 {
+			compatible = "qcom,halliday-tlmm";
+			reg = <0 0x0f100000 0 0x300000>;
+			interrupts = <GIC_SPI 208 IRQ_TYPE_LEVEL_HIGH>;
+			gpio-controller;
+			#gpio-cells = <2>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			gpio-ranges = <&tlmm 0 0 225>;
+			wakeup-parent = <&pdc>;
+		};
+
+		apps_smmu: iommu@15000000 {
+			compatible = "qcom,halliday-smmu-500", "qcom,smmu-500", "arm,mmu-500";
+			reg = <0 0x15000000 0 0x100000>;
+			#iommu-cells = <2>;
+			#global-interrupts = <1>;
+			interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 99 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 100 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 104 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 109 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 110 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 181 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 182 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 183 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 184 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 185 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 186 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 187 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 188 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 189 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 190 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 191 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 192 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 315 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 316 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 317 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 318 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 319 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 320 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 321 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 322 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 323 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 324 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 325 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 326 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 327 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 328 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 329 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 330 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 331 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 332 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 333 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 334 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 335 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 336 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 337 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 338 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 339 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 340 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 341 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 342 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 343 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 344 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 345 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 395 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 396 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 397 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 398 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 399 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 400 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 401 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 402 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 403 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 404 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 405 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 406 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 407 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 408 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 409 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 418 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 419 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 412 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 421 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 707 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 423 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 424 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 425 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 690 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 691 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 692 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 693 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 694 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 695 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 696 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 697 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 410 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 708 IRQ_TYPE_LEVEL_HIGH>;
+			dma-coherent;
+		};
+
+		intc: interrupt-controller@17200000 {
+			compatible = "arm,gic-v3";
+			reg = <0 0x17200000 0 0x10000>,
+			      <0 0x17260000 0 0x100000>;
+			#interrupt-cells = <3>;
+			interrupt-controller;
+			#redistributor-regions = <1>;
+			redistributor-stride = <0 0x20000>;
+			interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_LOW>;
+		};
+
+		timer@17420000 {
+			compatible = "arm,armv7-timer-mem";
+			reg = <0 0x17420000 0 0x1000>;
+			ranges = <0 0 0 0x20000000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			frame@17421000 {
+				reg = <0x17421000 0x1000>,
+				      <0x17422000 0x1000>;
+				frame-number = <0>;
+				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
+			};
+
+			frame@17423000 {
+				reg = <0x17423000 0x1000>;
+				frame-number = <1>;
+				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
+
+				status = "disabled";
+			};
+
+			frame@17425000 {
+				reg = <0x17425000 0x1000>;
+				frame-number = <2>;
+				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
+
+				status = "disabled";
+			};
+
+			frame@17427000 {
+				reg = <0x17427000 0x1000>;
+				frame-number = <3>;
+				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
+
+				status = "disabled";
+			};
+
+			frame@17429000 {
+				reg = <0x17429000 0x1000>;
+				frame-number = <4>;
+				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
+
+				status = "disabled";
+			};
+
+			frame@1742b000 {
+				reg = <0x1742b000 0x1000>;
+				frame-number = <5>;
+				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
+
+				status = "disabled";
+			};
+
+			frame@1742d000 {
+				reg = <0x1742d000 0x1000>;
+				frame-number = <6>;
+				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
+
+				status = "disabled";
+			};
+		};
+
+		apps_rsc: rsc@17a00000 {
+			compatible = "qcom,rpmh-rsc";
+			reg = <0 0x17a00000 0 0x10000>,
+			      <0 0x17a10000 0 0x10000>,
+			      <0 0x17a20000 0 0x10000>;
+			reg-names = "drv-0", "drv-1", "drv-2";
+			label = "apps_rsc";
+			interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>;
+			power-domains = <&cluster_pd>;
+			qcom,tcs-offset = <0xd00>;
+			qcom,drv-id = <2>;
+			qcom,tcs-config = <ACTIVE_TCS 3>, <SLEEP_TCS 2>,
+					  <WAKE_TCS 2>, <CONTROL_TCS 0>;
+
+			apps_bcm_voter: bcm-voter {
+				compatible = "qcom,bcm-voter";
+			};
+
+			rpmhcc: clock-controller {
+				compatible = "qcom,halliday-rpmh-clk";
+				#clock-cells = <1>;
+				clocks = <&xo_board>;
+				clock-names = "xo";
+			};
+
+			rpmhpd: power-controller {
+				compatible = "qcom,halliday-rpmhpd", "qcom,sm8450-rpmhpd";
+				#power-domain-cells = <1>;
+				operating-points-v2 = <&rpmhpd_opp_table>;
+
+				rpmhpd_opp_table: opp-table {
+					compatible = "operating-points-v2";
+
+					rpmhpd_opp_ret: opp-16 {
+						opp-level = <RPMH_REGULATOR_LEVEL_RETENTION>;
+					};
+
+					rpmhpd_opp_low_svs: opp-64 {
+						opp-level = <RPMH_REGULATOR_LEVEL_LOW_SVS>;
+					};
+
+					rpmhpd_opp_low_svs_l1: opp-80 {
+						opp-level = <RPMH_REGULATOR_LEVEL_LOW_SVS_L1>;
+					};
+
+					rpmhpd_opp_svs: opp-128 {
+						opp-level = <RPMH_REGULATOR_LEVEL_SVS>;
+					};
+
+					rpmhpd_opp_svs_l0: opp-144 {
+						opp-level = <RPMH_REGULATOR_LEVEL_SVS_L0>;
+					};
+
+					rpmhpd_opp_svs_l1: opp-192 {
+						opp-level = <RPMH_REGULATOR_LEVEL_SVS_L1>;
+					};
+
+					rpmhpd_opp_svs_l2: opp-224 {
+						opp-level = <RPMH_REGULATOR_LEVEL_SVS_L2>;
+					};
+
+					rpmhpd_opp_nom: opp-256 {
+						opp-level = <RPMH_REGULATOR_LEVEL_NOM>;
+					};
+
+					rpmhpd_opp_nom_l0: opp-288 {
+						opp-level = <RPMH_REGULATOR_LEVEL_NOM_L0>;
+					};
+
+					rpmhpd_opp_nom_l1: opp-320 {
+						opp-level = <RPMH_REGULATOR_LEVEL_NOM_L1>;
+					};
+
+					rpmhpd_opp_nom_l2: opp-336 {
+						opp-level = <RPMH_REGULATOR_LEVEL_NOM_L2>;
+					};
+
+					rpmhpd_opp_turbo: opp-384 {
+						opp-level = <RPMH_REGULATOR_LEVEL_TURBO>;
+					};
+
+					rpmhpd_opp_turbo_l0: opp-400 {
+						opp-level = <RPMH_REGULATOR_LEVEL_TURBO_L0>;
+					};
+
+					rpmhpd_opp_turbo_l1: opp-416 {
+						opp-level = <RPMH_REGULATOR_LEVEL_TURBO_L1>;
+					};
+
+					rpmhpd_opp_turbo_l2: opp-432 {
+						opp-level = <RPMH_REGULATOR_LEVEL_TURBO_L2>;
+					};
+				};
+			};
+		};
+
+		epss_l3: interconnect@17d90000 {
+			compatible = "qcom,halliday-epss-l3", "qcom,epss-l3";
+			reg = <0 0x17d90000 0 0x1000>;
+			clocks = <&rpmhcc RPMH_CXO_CLK>, <&gcc GCC_GPLL0>;
+			clock-names = "xo", "alternate";
+			#interconnect-cells = <1>;
+		};
+
+		cpufreq_hw: cpufreq@17d91000 {
+			compatible = "qcom,halliday-cpufreq-epss", "qcom,cpufreq-epss";
+			reg = <0 0x17d91000 0 0x1000>,
+			      <0 0x17d92000 0 0x1000>;
+			reg-names = "freq-domain0", "freq-domain1";
+			clocks = <&rpmhcc RPMH_CXO_CLK>, <&gcc GCC_GPLL0>;
+			clock-names = "xo", "alternate";
+			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "dcvsh-irq-0", "dcvsh-irq-1";
+			#freq-domain-cells = <1>;
+			#clock-cells = <1>;
+		};
+
+		gem_noc: interconnect@19100000 {
+			compatible = "qcom,halliday-gem-noc";
+			reg = <0 0x19100000 0 0xa9080>;
+			#interconnect-cells = <2>;
+			qcom,bcm-voters = <&apps_bcm_voter>;
+		};
+
+		nsp_noc: interconnect@320c0000 {
+			compatible = "qcom,halliday-nsp-noc";
+			reg = <0 0x320c0000 0 0x10000>;
+			#interconnect-cells = <2>;
+			qcom,bcm-voters = <&apps_bcm_voter>;
+		};
+	};
+
+	thermal-zones {
+		aoss0-thermal {
+			thermal-sensors = <&tsens0 0>;
+
+			trips {
+				aoss0-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				aoss0-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+
+		aoss1-thermal {
+			thermal-sensors = <&tsens1 0>;
+
+			trips {
+				aoss1-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				aoss1-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+
+		camera0-thermal {
+			thermal-sensors = <&tsens1 5>;
+
+			trips {
+				camera0-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				camera0-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+
+		camera1-thermal {
+			thermal-sensors = <&tsens1 6>;
+
+			trips {
+				camera1-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				camera1-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+
+		cpu0-0-thermal {
+			thermal-sensors = <&tsens0 3>;
+
+			trips {
+				cpu0-0-critical {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "critical";
+				};
+			};
+		};
+
+		cpu0-1-thermal {
+			thermal-sensors = <&tsens0 4>;
+
+			trips {
+				cpu0-1-critical {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "critical";
+				};
+			};
+		};
+
+		cpu1-0-thermal {
+			thermal-sensors = <&tsens0 5>;
+
+			trips {
+				cpu1-0-critical {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "critical";
+				};
+			};
+		};
+
+		cpu1-1-thermal {
+			thermal-sensors = <&tsens0 6>;
+
+			trips {
+				cpu1-1-critical {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "critical";
+				};
+			};
+		};
+
+		cpu2-0-thermal {
+			thermal-sensors = <&tsens0 7>;
+
+			trips {
+				cpu2-0-critical {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "critical";
+				};
+			};
+		};
+
+		cpu2-1-thermal {
+			thermal-sensors = <&tsens0 8>;
+
+			trips {
+				cpu2-1-critical {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "critical";
+				};
+			};
+		};
+
+		cpu3-0-thermal {
+			thermal-sensors = <&tsens0 9>;
+
+			trips {
+				cpu3-0-critical {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "critical";
+				};
+			};
+		};
+
+		cpu3-1-thermal {
+			thermal-sensors = <&tsens0 10>;
+
+			trips {
+				cpu3-1-critical {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "critical";
+				};
+			};
+		};
+
+		cpu4-0-thermal {
+			thermal-sensors = <&tsens0 11>;
+
+			trips {
+				cpu4-0-critical {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "critical";
+				};
+			};
+		};
+
+		cpu4-1-thermal {
+			thermal-sensors = <&tsens0 12>;
+
+			trips {
+				cpu4-1-critical {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "critical";
+				};
+			};
+		};
+
+		cpu5-0-thermal {
+			thermal-sensors = <&tsens0 13>;
+
+			trips {
+				cpu5-0-critical {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "critical";
+				};
+			};
+		};
+
+		cpu5-1-thermal {
+			thermal-sensors = <&tsens0 14>;
+
+			trips {
+				cpu5-1-critical {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "critical";
+				};
+			};
+		};
+
+		cpuss0_thermal: cpuss0-thermal {
+			thermal-sensors = <&tsens0 1>;
+
+			trips {
+				cpuss0-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				cpuss0-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+
+		cpuss1_thermal: cpuss1-thermal {
+			thermal-sensors = <&tsens0 2>;
+
+			trips {
+				cpuss1-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				cpuss1-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+
+		ddr-thermal {
+			thermal-sensors = <&tsens0 15>;
+
+			trips {
+				ddr-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				ddr-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+
+		gpuss0-thermal {
+			thermal-sensors = <&tsens1 7>;
+
+			trips {
+				gpuss0-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				gpuss0-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+
+		gpuss1-thermal {
+			thermal-sensors = <&tsens1 8>;
+
+			trips {
+				gpuss1-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				gpuss1-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+
+		gpuss2-thermal {
+			thermal-sensors = <&tsens1 9>;
+
+			trips {
+				gpuss2-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				gpuss2-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+
+		gpuss3-thermal {
+			thermal-sensors = <&tsens1 10>;
+
+			trips {
+				gpuss3-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				gpuss3-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+
+		gpuss4-thermal {
+			thermal-sensors = <&tsens1 11>;
+
+			trips {
+				gpuss4-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				gpuss4-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+
+		gpuss5-thermal {
+			thermal-sensors = <&tsens1 12>;
+
+			trips {
+				gpuss5-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				gpuss5-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+
+		gpuss6-thermal {
+			thermal-sensors = <&tsens1 13>;
+
+			trips {
+				gpuss6-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				gpuss6-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+
+		gpuss7-thermal {
+			thermal-sensors = <&tsens1 14>;
+
+			trips {
+				gpuss7-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				gpuss7-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+
+		nsp0-thermal {
+			thermal-sensors = <&tsens1 1>;
+
+			trips {
+				nsp0-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				nsp0-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+
+		nsp1-thermal {
+			thermal-sensors = <&tsens1 2>;
+
+			trips {
+				nsp1-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				nsp1-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+
+		nsp2-thermal {
+			thermal-sensors = <&tsens1 3>;
+
+			trips {
+				nsp2-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				nsp2-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+
+		video-thermal {
+			thermal-sensors = <&tsens1 4>;
+
+			trips {
+				video-critical {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+
+				video-hot {
+					temperature = <110000>;
+					hysteresis = <1000>;
+					type = "hot";
+				};
+			};
+		};
+	};
+
+	timer {
+		compatible = "arm,armv8-timer";
+		interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_LOW>,
+			     <GIC_PPI 14 IRQ_TYPE_LEVEL_LOW>,
+			     <GIC_PPI 11 IRQ_TYPE_LEVEL_LOW>,
+			     <GIC_PPI 10 IRQ_TYPE_LEVEL_LOW>;
+	};
+};

-- 
2.55.0

