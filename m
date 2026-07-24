Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4550E37A4AB
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 06:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784872868; cv=none; b=MZUXJLi7Di3LTeh8AEa4m15W6XfKFx3ayUaNBiwt4VGottiRGMOhj+TjQNU1fQXMygL3Or6dOz1iRiQ+vINCf/07nX5jgKuJ77+8rslnRPS56jaLgKqofXhFn2hsr1QXDQl1M5dzIZGa5LuTMwp1PE45pkHAaG7kuSWYhvawzC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784872868; c=relaxed/simple;
	bh=IdAz2TyrC6Gyu0QHelRU42XhSxa5ji1VRbMpKPGE8qI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YtaFsddusW55iwLg61pSF+AP8MOetEm1g4wQCxzTNvZ9n9nJMevN05UwoxXtJuC9G4ROyQYLnx2ypQ2la/ykxcpBhTDcDbpjxRTZSFgppfKVCLmdVi/u+9KiiDTi2PTufQTgC5UThIUzs7AZmDcMS+9VeTnsTK51uRGW4R9YfTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=ZTHdmjB9; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="ZTHdmjB9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:message-id:date:subject:
	 cc:to:from:from:to:cc:reply-to:subject:date:in-reply-to:references:
	 list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=ITskY/zqT/YS8CODJ4tJmD9apiu+jrDBpX0HeGmYkG0=;
	b=ZTHdmjB9BH58DZ05aITomcknrNmY3I02wqCmrpYNa8NU2NWuf6BAkqbA7pGdSYiG6ZFVk7fDUl1Qv
	 KIIakkVKtzh21gFscDfSrhU0GnVqdwQlcAWnA3Oubz++81wc7tr/S08jGj3oSN0GP9FdYu6uKfF+Cr
	 s8tjnGBvy595UZVQhFIuCBgWhH1BMdATREfOAL/fDvoTVliTcLcGcHT1nEnwNLCX9pOzuxOiNwNWBG
	 Nn5DgakAmUhbygJsDI1YKpL5cHfojN8mjz3VRuuulRYkTasWLahSbDPUBA9FLJFVtvXP/6FA3ulMjl
	 NnNFV2CJByBwClqerwqpEKCWR55vXBg==
Received: from kaipn1.makisara.private (91-158-174-119.elisa-laajakaista.fi [91.158.174.119])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id e32ce17c-8724-11f1-8e46-005056bdf889;
	Fri, 24 Jul 2026 08:59:53 +0300 (EEST)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH] MAINTAINERS: Orphan the SCSI tape driver
Date: Fri, 24 Jul 2026 08:59:23 +0300
Message-ID: <20260724055923.4793-1-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Time to retire from the role of maintainer.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
Applies to 7.3/staging.

 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9a66b11ea521..c68d108e4646 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24300,9 +24300,8 @@ F:	include/uapi/scsi/
 F:	include/ufs/
 
 SCSI TAPE DRIVER
-M:	Kai Mäkisara <Kai.Makisara@kolumbus.fi>
 L:	linux-scsi@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	Documentation/scsi/st.rst
 F:	drivers/scsi/st.*
 F:	drivers/scsi/st_*.h
-- 
2.51.0

