Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748871B86C9
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 13:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723813202; cv=none; b=L/JLiqvBkA1jrPEgLtdW7F80zYFEAhdDnKO40No7DUF0+87EjSk6AkbXVGF/nuFjFiNxzq5jNkRwuxJiumNZSi7MsJQdP+FwxwEQOSgMXFmT4FozUfSPe/ZKKe8VmLP7RIjmJfcFVjikL6aK8y+f57Ur8Ps/yJKUECRewP95UtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723813202; c=relaxed/simple;
	bh=VZd2qYCV7LwSPKDLqPc3zbwbKzTtehqqlwBt1PO6YZM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=hUyKFidaTZbUJQhe7+3jFWz6aSXCBmEEbSXU22jqVsnAlTAm/2echWKZ/poS7CqXHbp7mt6uiHD6Kit8/rYT/UI7pgH0AndxtuqaMrlM9UETFWl2fBOFA8NoCIEoZLgNzzHhOxs4/Mccq6RUVYtTo5N1Xq0VTyUdPD0aJj8cbzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ED3fIAoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ED3fIAoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44514C32782;
	Fri, 16 Aug 2024 13:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723813201;
	bh=VZd2qYCV7LwSPKDLqPc3zbwbKzTtehqqlwBt1PO6YZM=;
	h=From:Date:Subject:To:Cc:From;
	b=ED3fIAojib0S2ly69BBTyJ5gjRkPqhsAcwcztrD42RaRF+N3MvNf45xJRT9y04Dnm
	 MtWd/c7CG+q9Ge7GSWpOuyyHQqmV33YTT4GS6D4TOUNbNoPlgIfNwlsVs//DRYsTc8
	 yHCrNLoLAGyPGkaWvNRICk6v1WN+pnD8JUL+fZHFyqJxhN3fkX4/mUfe+hdn22U3tu
	 5WT+9THhl/gMtlB1nZf0kRkobGQ4Y0ZDrq+SFKiMQhpdttUzN2hslKRzB247S6TUn2
	 7rvr6SpapPul3vxDJnmWoT5j6n1jjcDz7ToXRA/dhtvauwAI8itcossEwXJRQljnkI
	 mkW+qRrAPQOTQ==
From: Simon Horman <horms@kernel.org>
Date: Fri, 16 Aug 2024 13:59:56 +0100
Subject: [PATCH] MAINTAINERS: Add header files to SCSI SUBSYSTEM
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20240816-scsi-mnt-v1-1-439af8b1c28b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAEtNv2YC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxMDC0Mz3eLk4kzd3LwSXTNz40STpCQDc4tkAyWg8oKi1LTMCrBR0bG1tQB
 DSI1GWgAAAA==
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
X-Mailer: b4 0.14.0

This is part of an effort to assign a section in MAINTAINERS to header
files that relate to Networking [1]. In this case the files with "net" in
their name.

[1] https://lore.kernel.org/netdev/20240816-net-mnt-v1-0-ef946b47ced4@kernel.org/

As part of that effort these files came up:
* include/uapi/scsi/scsi_netlink_fc.h
* include/uapi/scsi/scsi_netlink.h

Unlike all the other matching files, these one seem to relate more
closely to SCSI than Networking, so I have added them to the SCSI
SUBSYSTEM section.

In order to simplify things, and for consistency, I have added the
entire include/uapi/scsi rather than the individual files.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 42decde38320..c2b41ddb8536 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20351,6 +20351,7 @@ F:	Documentation/devicetree/bindings/scsi/
 F:	drivers/scsi/
 F:	drivers/ufs/
 F:	include/scsi/
+F:	include/uapi/scsi/
 
 SCSI TAPE DRIVER
 M:	Kai Mäkisara <Kai.Makisara@kolumbus.fi>

