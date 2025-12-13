Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1497E110;
	Sat, 13 Dec 2025 15:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765638189; cv=none; b=du8XkQat0edNiIz8b1lYGoXxzl+kPs2l1Lj7CberZJ5QAcb5Zz5ILf5r9sKiOr4tjBMxjrDrxVib0okVYb23097cbwIny0aI9mmNhIK2U/kNFYjY12zDB9glf6RRwFGUnZ6X6ftM3RsWhU4v/kdPq079G6Gx2yFDtNZLor9f138=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765638189; c=relaxed/simple;
	bh=AqCmAozaniNHX5GBUBFsaP58Sd82/tS4JqKE9BRjjhQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=OBdTk2spHbfQ+NdNxe59NTTU3X0euXwqAoP1XZS0GPn63Y2PJrGy6TprUT9SlD0d5b+eHDVvNLqiI9aMUgC9BIN0OBd7fXRjyQfbQsIe4/YmhLoFggKBYrQn9wWCCPiHA7G0b3cGbQvehnEsFJByiZq7yWPIF/McWwVYmJ0npYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ExOVUnqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ExOVUnqy"
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD65FC4CEF7;
	Sat, 13 Dec 2025 15:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765638188;
	bh=AqCmAozaniNHX5GBUBFsaP58Sd82/tS4JqKE9BRjjhQ=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=ExOVUnqyqoBpcbGz6TSB3wdYU9CkZzEW6eFdnvXLnRr9EP9qUeMiGWJ5BT2V6KaUq
	 zMD3pqol7/z+Y7arrL2udJc5pHu2vnRMMGJvN6thCJsMAdnidzXDIt5pMjCCeNula7
	 opvkqx58N7C+UufP75sTTyyE/Lvd3fQGOImFwm34BuaTAfPW8bXy0vlq0XCDI9CwTv
	 GQPENPDUYE+H1QBqbLfL6NiBpK48MaN9vGVooYLZPFr0W5pXOu2GibbvdKJncGOvPS
	 UBfLZzEJkFeKZbTaTKhYnH3K4/bzevnOQLnnooGG4/uCwZttz8/tmqM0lkTfzxuG+y
	 j5W959eZkBmCw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2B9D5B158;
	Sat, 13 Dec 2025 15:03:08 +0000 (UTC)
From: Zhaoming Luo via B4 Relay <devnull+zhml.posteo.com@kernel.org>
Date: Sat, 13 Dec 2025 23:04:11 +0800
Subject: [PATCH v2] dt-bindings: ufs: Fix a grammar error
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251213-fix-minor-grammar-err-v2-1-b32be57caa13@posteo.com>
X-B4-Tracking: v=1; b=H4sIAGqAPWkC/x2MQQqAMAzAviI9W9gqKvoV8TBcpz1sSgciDP/u8
 BhIUiCzCmeYmwLKt2Q5UwVqG9gOl3ZG8ZWBDPWWbIdBHoySTsVdXYxOkVVxGL01W6DgJw+1vZS
 r+H+X9X0/tnyRPWcAAAA=
X-Change-ID: 20251213-fix-minor-grammar-err-67d10cf2fd9d
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Zhaoming Luo <zhml@posteo.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1440; i=zhml@posteo.com;
 h=from:subject:message-id;
 bh=fori8aM450W7B3/fTbmPAYSMy/U8i5ZeqbO0a1qO7mc=;
 b=owGbwMvMwCWW8vrrboHTHcGMp9WSGDJtG1o+qz+J/6IurKsm+/8KI3PRDKb3Ka2T9+Y5iee4R
 7hHPzzWMZGFQYyLwVJMkcU57kHABd8el8DWY54wc1iZQIZIizQwAAELA19uYl6pkY6Rnqm2oZ6h
 oQ6QycDFKQBT/bqJkWHj3Nv8HTM7TP65uV5R3PjMnicx65JYDeeyxaac3WsqNv9n+GcyIz4uR0p
 63bmJ/+o3LzqQFPR0CpujSvcOqebQa0E/vrMBAA==
X-Developer-Key: i=zhml@posteo.com; a=openpgp;
 fpr=435EE050D04D8C445185C64964EBF5BB10CB8853
X-Endpoint-Received: by B4 Relay for zhml@posteo.com/default with
 auth_id=576
X-Original-From: Zhaoming Luo <zhml@posteo.com>
Reply-To: zhml@posteo.com

From: Zhaoming Luo <zhml@posteo.com>

Fix a minor grammar error.

Signed-off-by: Zhaoming Luo <zhml@posteo.com>
---
Changes from v1[0]:
- The subject prefixes match the subsystem as suggested in the
  documentation[1].
- The necessary To/Cc entries are included.

Thanks to Krzysztof Kozlowski for pointing out the errors and providing
helpful information about how to fix them.

[0]: https://lore.kernel.org/linux-scsi/20251212131112.5516-1-zhml@posteo.com/
[1]: https://www.kernel.org/doc/html/latest/devicetree/bindings/submitting-patches.html#i-for-patch-submitters
---
 Documentation/devicetree/bindings/ufs/ufs-common.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
index 9f04f34d8..efeae8f3d 100644
--- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
+++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
@@ -48,7 +48,7 @@ properties:
     enum: [1, 2]
     default: 2
     description:
-      Number of lanes available per direction.  Note that it is assume same
+      Number of lanes available per direction.  Note that it is assumed same
       number of lanes is used both directions at once.
 
   vdd-hba-supply:

---
base-commit: 9d9c1cfec01cdbf24bd9322ed555713a20422115
change-id: 20251213-fix-minor-grammar-err-67d10cf2fd9d

Best regards,
-- 
Zhaoming Luo <zhml@posteo.com>


