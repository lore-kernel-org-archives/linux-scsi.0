Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793817505;
	b=vT5ORKHVaQfhKl51iKXnIiw9vryMtBX10BG1UdzTvhEF1v9VXexx7UhCQX8A9ZEE5cdx
	 W2RM7avPquhlb9cjmjdVo1+OKZg01cczkEQhTckAIBkRku9obd6oeLqmM6vKUtNoOQ1JD
	 PANyHwwCmqywNQwVWZh0yVci39KQGDqTrAreCbMxhaq1Q0tfo8VBFt/nFobQ5dQgB/D3A
	 GKx86fwD41fqjCxbStKbDELUFPaVsj8Yhi6mm2siixPA4zAHqx/f1kr+uyiPkdSKrAqXi
	 dnEBqc644Xo8jkozaeykAlQXDrE9un07VSlyjRN/StqouStrIlDms4EwiCMpCyVzcVQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817505;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=kjCSLYkElyGJvKYAsH4sNDGhqXKOLz26uY3GRFmiYE8=;
	b=KsXhL8om4aU53P9HqhNfdiwT34rrQEXOof3BHGcU+VMTLXWvmkRoNUJXXTzsN9xPVPph
	 xDHgibwRE2MTxsaRNdGiHwDMIUlY/BJVAwwZ1EUeeQrZPU7vC56PYI1Se5+noACEyApzI
	 1cXN9v+IlbUrSqa7P10U/vrqFoMmUi49ICVIlNhEBZS5Vxl5sSw01wA7+nnqbjG45hN/j
	 F+dwnQypVsEfAxBX8m3f9Cbtj1zeJXRn2LjFniRU+cZNhX8KB6FIQJyPckzVJdSMrbG6X
	 qm50Sk+cUm2cJvVl+3y22IJVl92G4EyK1lVeCilEkIaZze78dxj6qZDP61d/ZVhSLEw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FEgFp+s7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5CB606A326;
	Wed,  4 Nov 2026 18:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FEgFp+s7
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793817505;
	b=CG/+JxbI/nuWrahg96M6HyLck/HMymXhG4NgllYxM/Vy0HmvqLMdDeTZqSXKDG9u9d/I
	 mKejYD6BO/TD0bB6C3U+I0pfSRj8s3DQrbem2WX5FbGvQfYtu5MQkkYkMoA3FzRxkuBMQ
	 URizgJwboF2bXJXQp/0sRIyM0bClLTemOFpjcVSJ1tuLJ7JcHGkVPlDV7gBbZsW0YonUn
	 izlrFW2hpuUoO/670HQ2e2j1S9aZjlSGFCUXnjjjX0i0X/S2NlO286vG6Jk8836WP4BJ9
	 dXyc+eGxNPyTn2oElzTwtU+PzkYSq1YFQD7w1dEpUghAulnoy2Q4nVqh6sKliOtjffg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793817505;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=kjCSLYkElyGJvKYAsH4sNDGhqXKOLz26uY3GRFmiYE8=;
	b=U5TSmZJNiBfowOgVpo3dPHOBXPe8ZMqzpSzjqzwoqIRijFWlcyFyOBHuVwiYYrPYr7o1
	 VL2d6lsotKIXpa/C6Qm5Dir1dJ6TzYFZqKh4Voz0YZQ499ccZjSNLfIfgMpS4yH6WOb75
	 tatVsN4ggACjn7Ea8IcoTabjxTT7oq2EezkGcH3ZNYhQfPMUVfhao5nGOODQjZdXIhwTn
	 YiVLv/X2dbAs13KlSZATIp/YVNpqMfCFACMKROIvNElDqE7A9LIMRJDnskHx48kTKr7SE
	 TreOsTspNPVFQsoBoIm6b71hZ4eDMPOucObf3klzj4tEO6+ObTKf4a0hnUh7Yn3I/1w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 619F01F00A16;
	Wed,  4 Nov 2026 18:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793817504;
	bh=kjCSLYkElyGJvKYAsH4sNDGhqXKOLz26uY3GRFmiYE8=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=FEgFp+s7JLYTSaQRbnYafNYot9KInDcdTK7w/TyuZalwutknx+ALu+oERTbQLHDYE
	 OIn9mj09VXw1QVP2ZG5meffudgvKNLKG3GYHk2eqQwdpsQ9jP41+K4WtvmevoTY2Xq
	 tzVK+118sQJAHmHfJnflRV3SSCUpyg4gJ6rQMOw0KE6/T0Zt9mx+hmCW551Fz3GKcL
	 7PAOKffLyF/nhdigDVntD3BzHVgNQYPPHoBT+L8oFi+LCWgN6e6HcqQZp9jc6Z7Tb6
	 gTFUlP+8MK38M+0Lzi8znL4qMBuxyFjICI4F/abinK60ok7BKBCM60Po7N9X7A10F5
	 POrWHvN6RRQyg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B742946F34;
	Wed,  4 Nov 2026 18:38:23 +0000 (UTC)
From: Andrew Gigena via B4 Relay <devnull+mail.andrewgigena.dev@kernel.org>
Subject: [PATCH v2 0/2] arm64: dts: qcom: sm8150: Add standalone ICE node
 for UFS
Date: Wed, 04 Nov 2026 18:38:11 +0000
Message-Id: <20261104-sm8150-ice-rfc-v2-0-d697bbce0278@andrewgigena.dev>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WNyw6CMBBFf4XM2pppecaV/2FY0GGAMbGQFquG8
 O8Crl2e5NxzFwjshQNckgU8Rwkyug3MKQEaGtezknZjMGgKrTFT4VHpHJUQK9+RQptZQ5jmXCF
 so8lzJ+8jeKt/HJ72zjTvld0YJMyj/xyPUe/e33jUClVepqUtyDARXhvXen710rNrzi1HqNd1/
 QKM9s3yxQAAAA==
X-Change-ID: 20261104-sm8150-ice-rfc-0b4b2c035e80
To: Abel Vesa <abelvesa@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Bjorn Andersson <andersson@kernel.org>, Andy Gross <agross@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, Andrew Gigena <mail@andrewgigena.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793817503; l=1778;
 i=mail@andrewgigena.dev; s=20261104; h=from:subject:message-id;
 bh=EYYDw/tfOLuPl22DSLCCU8f7CgFbqXXJ5pXhEipb5G4=;
 b=kp8or87NIVZSizcmjfJxMsBDmwAMDFADyUHX9ZpCifKsu+M7gWCsUUg5i0rRWaJA7hvSsYkTO
 z3gr7fGK/u5B0+6JLErzPTeCyQeCPRJ4PtjayE0fw+pZ4f5Cl1xrNX2
X-Developer-Key: i=mail@andrewgigena.dev; a=ed25519;
 pk=OMhlYIBaOEC8g4mJ4JCKy7kbg+lrwRxuujieZF8Ne6U=
X-Endpoint-Received: by B4 Relay for mail@andrewgigena.dev/20261104 with
 auth_id=1402
X-Original-From: Andrew Gigena <mail@andrewgigena.dev>
Reply-To: mail@andrewgigena.dev

Hi everyone,

This small series brings the Qualcomm Inline Crypto Engine (ICE) to the
SM8150 (Snapdragon 855) platform, following the same standalone-node style
already used on SM8250 and newer SoCs.

The first patch documents the new qcom,sm8150-inline-crypto-engine
compatible and moves qcom,sm8150-ufshc to the standalone-ICE UFS binding.
The second patch converts the UFS node to reference a dedicated ICE node
instead of embedding the registers directly.

I've tested this on a Google Pixel 4 (google-flame) and everything works:
/sys/block/sda/queue/crypto now advertises AES-256-XTS and ext4 reports
encryption as "supported". The ICE self-test completes cleanly during boot.

Happy to adjust anything or add more details if needed. Thanks for reviewing!

Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>

Changes in v2:
- Move qcom,sm8150-ufshc from the legacy embedded-ICE UFS binding to
  the standalone-ICE UFS binding.
- Keep the SM8150 ICE compatible sorted in the existing list.
- Link to v1: https://patch.msgid.link/20261104-sm8150-ice-rfc-v1-0-5737b6c2ecc0@andrewgigena.dev

---
Andrew Gigena (2):
      dt-bindings: crypto: ice: Document sm8150 inline crypto engine
      arm64: dts: qcom: sm8150: Use standalone ICE node for UFS

 .../bindings/crypto/qcom,inline-crypto-engine.yaml |  1 +
 .../devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml |  2 ++
 .../devicetree/bindings/ufs/qcom,ufs.yaml          | 11 ++++------
 arch/arm64/boot/dts/qcom/sm8150.dtsi               | 25 ++++++++++++++--------
 4 files changed, 23 insertions(+), 16 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261104-sm8150-ice-rfc-0b4b2c035e80

Best regards,
--  
Andrew Gigena <mail@andrewgigena.dev>


