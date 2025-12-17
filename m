Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8EA363C61;
	Wed, 17 Dec 2025 14:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765980136; cv=none; b=s5o8Ab07EKLo8QPkVNwYyTU5kbrYthmX7HMOAcc4X9sQ71nRfPW1+DdYnhfTE7fFxjtzPiC6iIgDr0SfnH6M+11jHKtoNE26Vop8DgVHH5/+ir0DaquUkM1hoZpdSUI61ReMumnoLTeLr8JTwRkpZDqnMzVtA3XIoAEClHW6zgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765980136; c=relaxed/simple;
	bh=Hb4UeFoy5May/yLILWF9gvfgTJUI+SiMVLhgWKHXZPI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=E6Ja4Vy67Om26vF6iX/mAn8JWR4w23qO/fyjJQfez05GrwQyYa0bcJNvPKsydXdZxYvz5JCXK9k2qClw3UmLoUXQT6RocDd7i8sSdiyNm4EHaYm7GP7OtZPWTkoTG0ey4nYoYsuooH+Dm7lf/QhOb9zjxG5CyRe17tOsHxnVcOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=onVHe4JZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="onVHe4JZ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11536C4CEF5;
	Wed, 17 Dec 2025 14:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765980136;
	bh=Hb4UeFoy5May/yLILWF9gvfgTJUI+SiMVLhgWKHXZPI=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=onVHe4JZqF7DpfueVKVDL4Ml0Epevw60xNQuxoGVLPhAZekeJLFROQCz6k3Hj7W/x
	 4vFLTs0X6fbN7lLtFu8rkg3pAWj3JGvyDQtVGALgfGnLC7X3aubuc7kP5qx5/h4a8R
	 4aY2+e/BEE3mHRJQoSpj3NILNHfC8auAsDTlm13h6BRPRKTTkpcZqhSW43IRuSixO3
	 /0Qi6/mzLgKZYW14+ePx4SUDLUuDaY0cW2okkTrb13p7q/I6hVyo0JGfbc0YP3SDbP
	 CPZs6zO0JV6f0gxN2YEQ9TTNdSVQ01o3o04pk+Edp+WytL+SCkqSdzPBDu8X6135WZ
	 zFB/y7GtwOPbw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B47D6554E;
	Wed, 17 Dec 2025 14:02:15 +0000 (UTC)
From: Zhaoming Luo via B4 Relay <devnull+zhml.posteo.com@kernel.org>
Date: Wed, 17 Dec 2025 22:03:38 +0800
Subject: [PATCH v3] dt-bindings: ufs: Fix several grammar errors
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251217-fix-minor-grammar-err-v3-1-9be220cdd56a@posteo.com>
X-B4-Tracking: v=1; b=H4sIADm4QmkC/4WNQQ6DMAwEv4J8riviiKL21H9UHEJiwIcQ5CDUC
 vH3pnygx1ntzu6QWYUzPKodlDfJkuYC9lKBn9w8MkooDFRTY8hYHOSNUeakOKqL0SmyKt7aYGo
 /0BDuAcp2US7F0/vqCk+S16Sf82ajX/rPuBEa7C313LTeOWOfS8orp6tPEbrjOL7pa1sEuwAAA
 A==
X-Change-ID: 20251213-fix-minor-grammar-err-67d10cf2fd9d
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Zhaoming Luo <zhml@posteo.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1572; i=zhml@posteo.com;
 h=from:subject:message-id;
 bh=6xDHkeTv5R7oilb7pg+a2ov6MpBdcOcD/xUXTzcBvH8=;
 b=owGbwMvMwCWW8vrrboHTHcGMp9WSGDKddjhtZagOnHrPRvOi+9MGl9vVJvVcSa2fdl1QfnLbV
 GFVkWRcx0QWBjEuBksxRRbnuAcBF3x7XAJbj3nCzGFlAhkiLdLAAAQsDHy5iXmlRjpGeqbahnqG
 hjpAJgMXpwBMtaAPI8OPJzc3dhZs5r6ztUKBs/L/6l6R87vNq76XmcwTl++2f7OJ4Q9P3aIz86K
 WXDjS8nvXOe9DrAob9qcXrdvbqiX3OtfP1Y0BAA==
X-Developer-Key: i=zhml@posteo.com; a=openpgp;
 fpr=435EE050D04D8C445185C64964EBF5BB10CB8853
X-Endpoint-Received: by B4 Relay for zhml@posteo.com/default with
 auth_id=576
X-Original-From: Zhaoming Luo <zhml@posteo.com>
Reply-To: zhml@posteo.com

From: Zhaoming Luo <zhml@posteo.com>

Fix several grammar errors.

Signed-off-by: Zhaoming Luo <zhml@posteo.com>
---
Changes in v3:
- Further improvement on the grammar as suggested by Rob Herring.
  See https://lore.kernel.org/linux-scsi/20251217010112.GA3464453-robh@kernel.org/
- Link to v2: https://lore.kernel.org/r/20251213-fix-minor-grammar-err-v2-1-b32be57caa13@posteo.com

Changes in v2:
- The subject prefixes match the subsystem as suggested in the
  documentation.
- The necessary To/Cc entries are included.
- Link to v1: https://lore.kernel.org/linux-scsi/20251212131112.5516-1-zhml@posteo.com/
---
 Documentation/devicetree/bindings/ufs/ufs-common.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
index 9f04f34d8..ed97f5682 100644
--- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
+++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
@@ -48,8 +48,8 @@ properties:
     enum: [1, 2]
     default: 2
     description:
-      Number of lanes available per direction.  Note that it is assume same
-      number of lanes is used both directions at once.
+      Number of lanes available per direction.  Note that it is assumed that
+      the same number of lanes are used in both directions at once.
 
   vdd-hba-supply:
     description:

---
base-commit: 9d9c1cfec01cdbf24bd9322ed555713a20422115
change-id: 20251213-fix-minor-grammar-err-67d10cf2fd9d

Best regards,
-- 
Zhaoming Luo <zhml@posteo.com>


