Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793847187;
	b=ST203Y7znIdtVk6Im8mY2dR77iLoTFC2spEI3qvaee0tvy5h/jx6ujs12PV2op7QZ4Da
	 tBEsEQw3yX9/exIiiMy9391mAZaiFhFOXM+kSUosr4djZR6dmr1Gk713t0CM0MQZH7NkM
	 kzhELVulcHeA4J29VCsKSwrHbqiHL4n38oOvb4bqFhCzpkDOiNV3gHwvkHO8llHtJ8zpC
	 OXWZ7X2sUfRT5BP8jXlowE+ZG6cyqa9BrQhGt1UfW++00csBT/KM3BHoXc0RYMo2tkhy0
	 UEszYRbJLwyNG5Mdeku8gE5fHDqszeCmTFLCjQKpKx2/Yi7OYgdcwFAfV1NUqmx5DtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793847187;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uM0Cw7/N4AuGZOpywSCNb4m81LuoZ20Z5pGl8NoLYy8=;
	b=XDhCNy4w7GvigeL/gXuztsnNgWDTfoBexGDw7TDbTWmdOCLz9SdhKEjtSWTzy12DNwIE
	 SZJ4Mu4GRh54hiPQtwiXxp3+4KAdPi+129ytKRtOtUxMAsEXxqZSL7Wcfhz/7UipScDbg
	 xQxzqcFWAGw1Rbkt+MSpdctRK/xAXgyPZEB8i7NrGmA7vnoEJIywf4i0CoxhRPe7r9Qf4
	 Bva3etyBXB4vl+7+/xCd3w+XfytAmQdrhuOnLrP6uVrKgjcMyXEWsZaMdwc0vDwlxP5Xr
	 j9BTQo/F7HbT0GIHJwfZ3d6a+rxQnHptO4vXAp7OHo2AuCnVI/VveMb+vpmOWo3vS+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=Y2O8gX2u;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8396B606A31B;
	Thu,  5 Nov 2026 02:53:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8396B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=Y2O8gX2u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=Y2O8gX2ufTWwOqmmRWNd8SARyBynwC/BkHX90wKe2YfMaEBAGVudGVODGlqRsmpCTmYLzWgONHo4z
	 T/HJesPOLm54V035AV5GvPBZvlRveeZRyHGuLl6Tk+ektDq8T7eLEXrJoRfHLNLM2C5JpaGbZ9Kt+v
	 XCdvLWNAQIKq7tXU=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app09-12009 (RichMail) with SMTP id 2ee96aebef8730a-a729b;
	Thu, 05 Nov 2026 10:52:56 +0800 (CST)
X-RM-TRANSID:2ee96aebef8730a-a729b
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHB-W5100256 (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee96aebef868c9-36e9c;
	Thu, 05 Nov 2026 10:52:56 +0800 (CST)
X-RM-TRANSID:2ee96aebef868c9-36e9c
From: xujiahao <xujiahao@cmss.chinamobile.com>
To: Ram Vegesna <ram.vegesna@broadcom.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xujiahao <xujiahao@cmss.chinamobile.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] scsi: elx: libefc: bound the node display name components
Date: Thu,  5 Nov 2026 10:52:53 +0800
Message-ID: <20261105025254.1953-1-xujiahao@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

efc_node_update_display_name() concatenates two strings into
node->display_name, which is EFC_NAME_LENGTH (32) bytes, with

	snprintf(node->display_name, sizeof(node->display_name), "%s.%s",
		 nport->display_name, portid_display);

Both sources are declared as 32-byte arrays, so the format string allows
up to 31 + 1 + 31 bytes.  With W=1 gcc reports:

  efc_node.c:254:70: warning: '%s' directive output may be truncated
  writing up to 15 bytes into a region of size between 0 and 31
  [-Wformat-truncation=]

In practice the inputs are far shorter: nport->display_name is either
"s%06x" (7 characters) or "------", and portid_display is at most 6
characters, so the result never exceeds 14 characters.  Adding the
precision states that bound in the format string and makes the
concatenation fit the buffer by construction.

No functional change.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/all/202502182036.RChzXKS8-lkp@intel.com/
Signed-off-by: xujiahao <xujiahao@cmss.chinamobile.com>
---
 drivers/scsi/elx/libefc/efc_node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/libefc/efc_node.c b/drivers/scsi/elx/libefc/efc_node.c
index f17e052fe..f4bdeb79e 100644
--- a/drivers/scsi/elx/libefc/efc_node.c
+++ b/drivers/scsi/elx/libefc/efc_node.c
@@ -251,7 +251,7 @@ efc_node_update_display_name(struct efc_node *node)
 
 	efc_node_fcid_display(port_id, portid_display, sizeof(portid_display));
 
-	snprintf(node->display_name, sizeof(node->display_name), "%s.%s",
+	snprintf(node->display_name, sizeof(node->display_name), "%.15s.%.15s",
 		 nport->display_name, portid_display);
 }
 
-- 
2.43.0



