From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 54/83] scsi: ufs: Fix geometry descriptor size
Date: Tue, 12 Feb 2019 21:36:32 -0500
Message-ID: <20190213023701.20286-54-sashal@kernel.org>
References: <20190213023701.20286-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190213023701.20286-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Avri Altman <avri.altman@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Avri Altman <avri.altman@wdc.com>

[ Upstream commit 9be9db9f78f52ef03ee90063730cb9d730e7032b ]

Albeit we no longer rely on those hard-coded descriptor sizes, we still use
them as our defaults, so better get it right. While adding its sysfs
entries, we forgot to update the geometry descriptor size. It is 0x48
according to UFS2.1, and wasn't changed in UFS3.0.

[mkp: typo]

Fixes: c720c091222e (scsi: ufs: sysfs: geometry descriptor)
Signed-off-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 14e5bf7af0bb..c3bcaaec0fc5 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -195,7 +195,7 @@ enum ufs_desc_def_size {
 	QUERY_DESC_CONFIGURATION_DEF_SIZE	= 0x90,
 	QUERY_DESC_UNIT_DEF_SIZE		= 0x23,
 	QUERY_DESC_INTERCONNECT_DEF_SIZE	= 0x06,
-	QUERY_DESC_GEOMETRY_DEF_SIZE		= 0x44,
+	QUERY_DESC_GEOMETRY_DEF_SIZE		= 0x48,
 	QUERY_DESC_POWER_DEF_SIZE		= 0x62,
 	QUERY_DESC_HEALTH_DEF_SIZE		= 0x25,
 };
-- 
2.19.1
