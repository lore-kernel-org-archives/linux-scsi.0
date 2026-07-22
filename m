Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D6C43F4B9
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 22:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784760554; cv=none; b=RFSyVQhnm2l7qd4LSpTVJ2RKHIIX/HEjneebJ6v8mxPar7wA7SOrA8tAP4ogcqDBBGNSmHiRdiYlsMcXpiUQH9oYki7nEumT9fbyRU/X+9Q2Q7Ohg7oETpCz7oUmsYDdWm+ltisW/9DimWfDLd9KMm3M8/VcrFUFo4JuBUhfL0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784760554; c=relaxed/simple;
	bh=dNodA6343cPp33+A7P6P9PnJM96FKxYodxX6PafCi8s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XhTogeZE52GUtjE80TWxghSsNbzXr3l+rxDQncdDf+9nttjtsOhJNohxAMuvO7MY7dWSfM2v5wWCtQoNBimXdb8/qclCkqIHsyNbkcxCFORpHcwAOyWHfIbsjRa61kafNsOg473olFflrUSibBBPR+9fc103+mx3YvKy2WaDicY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=lzfnnNbv; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="lzfnnNbv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1784760552; x=1816296552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dNodA6343cPp33+A7P6P9PnJM96FKxYodxX6PafCi8s=;
  b=lzfnnNbvfpoHqWBDge33PG48DEUtBLD275bQ1WTqFHh4FWgU+knT8uHy
   pDvvtq5937jQOp5U6PF4frPIyWA7ZpSSEIMbDQGBzuKpz3LCNl/lJ3AHx
   o6OUwO8bMcLdQbFYOmmv2waf6qNAhxWkZ/FtccgwIgzLBYDoSOgk1L+Vf
   iRK8fqYFjTyov9dpikk3LGthTopRm4ztrlxfLjSbe04INdmoMqhqe0l5e
   jvt30av+nqUV8vvUyeUTVetKk7pt7PFnADhT9gSfGh2HFSBH3/kfrbc5W
   cdNJPKbHXO+Vk/HF6AOlfGD/rxGJcPuxPqtZjf2DQAP2pcvsabRFxLk37
   w==;
X-CSE-ConnectionGUID: L2Lc6N9QTAq10G+iN1covw==
X-CSE-MsgGUID: evllBBy1RU+jPaFJu2OGgQ==
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="228177622"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jul 2026 15:49:12 -0700
Received: from dks-rocky10u1-dev.pdev.net (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Wed, 22 Jul 2026 15:49:11 -0700
From: David Strahan <david.strahan@microchip.com>
To: <linux-scsi@vger.kernel.org>
CC: David Strahan <david.strahan@microchip.com>
Subject: Re: [PATCH] scsi: smartpqi: add new pci device-ids (please disregard, duplicate)
Date: Wed, 22 Jul 2026 17:48:46 -0500
Message-ID: <20260722224846.6616-1-david.strahan@microchip.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260722202327.5242-1-david.strahan@microchip.com>
References: <20260722202327.5242-1-david.strahan@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: chn-vm-ex01.mchp-main.com (10.10.85.143) To
 chn-vm-ex01.mchp-main.com (10.10.85.143)

Please disregard this patch and the three others posted in this same
thread (CCISS_BIG_PASSTHRU ioctl support, the AIO retry marker fix,
and the version bump to 2.1.42-011). They were sent by mistake, from
a stale local copy, without a cover letter or version tag.

A correctly formatted series covering the same 4 changes has been
posted separately as "[PATCH v1 0/4] smartpqi: fixes and updates for
2.1.42-011":

  https://lore.kernel.org/linux-scsi/20260722220401.6357-1-david.strahan@microchip.com/

Apologies for the noise.
