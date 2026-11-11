Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794419698;
	b=Px6ciBOhVIxxP0+vM1+ZwXqJmFK9/SVIlcym5cnY7wPyyLEWcfP37k7HQN4pNFWqQ4T7
	 3h+N22PYJED7FMiPrxNQ9+ucwAxL66rEBFLyMZH/8K23wfM3LjE2vkc5P+GZi9RveFH/5
	 hbnQl2hO1WDdhkyqg69+BsNKW6GrwbMIUt/pqpLN+h/+kq7BgejntiPPRG+/qRI+AM4lt
	 Sb5E6eEQ6nNbYYuwi/wuYWhtwEoaO6o+F/15vdkaWIO3Qj6JFhVhKwQvR6IzNdMmVx3Lc
	 Pp3E6E84tG2wlnW1x8OPLT8Lv+7GxLX1foGs95X8upU5qZY+QPVWrF/K76yEarEgTYg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794419698;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=2/e0Lvd7Sqz3iHPXMWwA53veJ/X35GUDoRLhWv/Rf1o=;
	b=u1R0MmErNsCZIAdpnN9eCF7atBMNgD34GSQk2nvaKkSyrydYRm5rQIvBRFbXjqAbTAa+
	 EioiBueJiIFAVAi+u7zO6/XnAU2ZJLgn0P8WcuKppwhJV2eDAovkLn8/Agyno9lerN641
	 jYnqr2R5qNInfoQTmQBdPlsnoxYCNDOcc3ZtpOKXE18g6AtHUJN3ie1nMfkhMz4Zn1hbY
	 N3ZuWI3RrStf4L8iLw9lf9nolSPisnsVQbFA9nXJzuCKAv/O1duhNJYRaxB3XaoF8ub9C
	 YDZXgbH3GbF5K6xfq+iOIBBTHONPoPwgOV709kWFcLEv+bH1amZnhdWOcH3gw+EKmwA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XVYcTEyV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCD3606A31C;
	Wed, 11 Nov 2026 17:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XVYcTEyV
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794419697;
	b=RlFLmbCUi2GT3o1c/j140nniBQSfKc1SB2bJcVDYGyOCPUR3SyQNa4VhFphd37rYMMy9
	 NGiIEWclB9sjWBwouOjh5PRwXHStKlpvHo8rYXFOg5IViVytFXtCnXmPuLijUEKM9gw+S
	 P2cyGmm6E4/S0c5FEVEbDBYnIfkJLco04ywbU0d6IvGyi44zl9O5i5f0oKCxfTYIjk5rE
	 razNbjZlRlBks5RQinxCsgzRLH4siBr1K0/AUWsGk1TX8+bZYGeelT1geUUMqnFc3siy4
	 czxu8j0ar/T+FvvEXQgKO5+IsdQe9ZRlcdirOJAs6lHPq2GSF53ehxLl4QsD6mqbCXg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794419697;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=2/e0Lvd7Sqz3iHPXMWwA53veJ/X35GUDoRLhWv/Rf1o=;
	b=t1ngS1c40tAmd7yAKy/EMhEoAR9mB1pblb1URTwWa/8s81Ux0C75UAq4Rmn0+VFxHFnL
	 7Bl79rRu6m3XaZI0dtAB3l7FG/aHugsQL9Qv/pkA086SbgjQRmek3k1DZV1uDYRtVDC6n
	 s3tKkZ0CR+/R8+i2FD0s30AQQWA27qGRDwKkuSQsGSAEAoapi8GXkYgO54eajENR4jTiI
	 VwhLhfiw/mE91NffuBx+PTjG8A7TvnyAXxnm2K8KEMfFQ/7q0YFA7GAb2YPMeGujULScQ
	 89qzy3VEcPc1Xz1jyMVMgHGk9IZ8p0bIzU8bbSFtDZSlYK5BOoyPa4jsmuizVaZaiRA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4CABA1F00A05;
	Wed, 11 Nov 2026 17:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794419697;
	bh=2/e0Lvd7Sqz3iHPXMWwA53veJ/X35GUDoRLhWv/Rf1o=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=XVYcTEyV00BY14+qs++vccbk07bfewEa/mBTOu/Z07zyTlEewUymdpr7Y/HNIGrDy
	 tgJlYNLuQJ9YPUXvhUUALjP+UBGfgT6k6+FgU/k2/BOH+UhUuV1oeuEORSM7lp+5Se
	 r3wMgWIV2lM/BhSIRjdeTODsxuENdi8RL6YK60bJurxBYRlgJozOLwK7FXLrlbFxnp
	 FpZUWPvNctIFJwk11SQRQ6trII+XwtjbPrReqynzHcHjEH/W4K00zYuehyYssvj9Wr
	 GGv9eq8Eaeb3cFxziTsgQVdZUaQM7F4EA+cfIlzMpLC7jUiujL/I8z/eRvMgkFtnY6
	 oCqyDa04Zcphg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CB8B84906D;
	Wed, 11 Nov 2026 17:54:56 +0000 (UTC)
From: Andrew Gigena via B4 Relay <devnull+mail.andrewgigena.dev@kernel.org>
Subject: [PATCH v4 0/3] arm64: dts: qcom: sm8150: Add standalone ICE node
 for UFS
Date: Wed, 11 Nov 2026 17:53:20 +0000
Message-Id: <20261111-sm8150-ice-rfc-v4-0-0311eac35609@andrewgigena.dev>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/33NzQ6CMBAE4FcxPVuzLZQfT76H8UC3C9REMC1WD
 eHdLXgxUTxOMvPNyDw5S57tNyNzFKy3fRdDut0wbKuuIW5NzEyCzISAlPtLIRRwi8RdjRx0qiV
 CoqgAFkdXR7V9LODx9M7+ps+Ew6zMjdb6oXfP5TGIubeKB8GBqzzJdYaSEOFQdcbRvbENddXOU
 GDzR5D/FRkVk5W51kgg82JFST4UIb6UJCp1aVRVQFZjqX4o0zS9AJRozkJRAQAA
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
 linux-scsi@vger.kernel.org, Andrew Gigena <mail@andrewgigena.dev>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794419696; l=1891;
 i=mail@andrewgigena.dev; s=20261104; h=from:subject:message-id;
 bh=ToMZN0TBCRPcQcR7ja+7EuF65OVoNHPNyts1YrPHW3E=;
 b=xdt1PgjbVpCJks9hfSRRbhxiZnBh2Ei4/7a75ITpnTDZzb2Ts2bJ/VHHmDyqoCR1pFF8MjdCE
 PvyQdHlDBFBCiRg8wcnEPRR7c4dZznU90qrNZhUIEpOmrsyv9wRWanL
X-Developer-Key: i=mail@andrewgigena.dev; a=ed25519;
 pk=OMhlYIBaOEC8g4mJ4JCKy7kbg+lrwRxuujieZF8Ne6U=
X-Endpoint-Received: by B4 Relay for mail@andrewgigena.dev/20261104 with
 auth_id=1402
X-Original-From: Andrew Gigena <mail@andrewgigena.dev>
Reply-To: mail@andrewgigena.dev

Hi everyone,

This series adds standalone ICE support to SM8150 (Snapdragon 855),
matching newer Qualcomm platforms.

Patch 1 documents the sm8150 ICE compatible.
Patch 2 moves sm8150-ufshc to the standalone-ICE UFS binding.
Patch 3 converts the UFS node to use a dedicated ICE node.

Tested on a Google Pixel 4 (google-flame): AES-256-XTS advertised,
ext4 encryption supported, ICE self-test passes.

Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>

Changes in v4:
- Add Krzysztof's Reviewed-by to patch 1.
- Document the transient dtbs_check warning for embedded-ICE DTs and why
  it has no practical impact (patch 2).
- Link to v3: https://patch.msgid.link/20261111-sm8150-ice-rfc-v3-0-f9d5a806fc95@andrewgigena.dev

Changes in v3:
- Split bindings into two commits (compatible + standalone-ICE move).
- Drop author Tested-by from DTS patch.
- Link to v2: https://patch.msgid.link/20261104-sm8150-ice-rfc-v2-0-d697bbce0278@andrewgigena.dev

Changes in v2:
- Move sm8150-ufshc to the standalone-ICE binding.
- Keep the ICE compatible sorted.
- Link to v1: https://patch.msgid.link/20261104-sm8150-ice-rfc-v1-0-5737b6c2ecc0@andrewgigena.dev

---
Andrew Gigena (3):
      dt-bindings: crypto: ice: document sm8150 compatible
      dt-bindings: ufs: qcom: classify sm8150-ufshc as standalone ICE
      arm64: dts: qcom: sm8150: use standalone ICE for UFS

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


