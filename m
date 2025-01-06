Received: from alln-iport-7.cisco.com (alln-iport-7.cisco.com [173.37.142.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6953A8821;
	Mon,  6 Jan 2025 22:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736203535; cv=none; b=JP8Cox+3JRRKIQQGXtu3f+WqlW38VK36W563M2+z2Orm3GQPebWfP3ynrQEPsozlj9uRuojrtQnCVtJsGVLWDRKxBDb/3sZgcY+Cf6ZzzQAvhdXqNmK3/Vhszf3yz6z3/4w+U2k4oz34/XYyExl5gt/gnawATvrp3fhUifxLCmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736203535; c=relaxed/simple;
	bh=jMYctyOgStI2zZ2AMhBzIJm7nFI7+CUExrDudzwj79M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P4t83S57/8sZSZiqYKbz7qVq53Va3SpJQ56TdRabU9TNSptvOhW2yJj3xbDPxdeK27smO4CIPv0M+Nv1RFKZz2u6hrdoqQaPG1+5zCie6LzKB1EjvbFRXosnDaf+LwFBarmIFbRgmiNlkP3X6z4A+wcSd1zc9I2OQ2nCv2wrZj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=Xfhb/WiE; arc=none smtp.client-ip=173.37.142.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Xfhb/WiE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1565; q=dns/txt; s=iport;
  t=1736203533; x=1737413133;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9PMdEQCFtlJ/DKjM4PdTjAUlJZJ9Um7jg2KJB8pUT1Y=;
  b=Xfhb/WiEDfIcmWZHTmcYDw65DGIyrDrBecOeYgHzyt/VdgSN6X2Nm8MZ
   SUIjalLtRlopjioQgk1pSos5EuxXQ3f5WJZz6YOQYrABFAvNMsh6GdMNT
   0zgGNjQXefXiM/UltNEvIz/whGZbmOIo4f+VYRBkPWfWMRcSmA9OtgQNp
   Y=;
X-CSE-ConnectionGUID: ftH/vGYFTnuqZqFLh3UlsA==
X-CSE-MsgGUID: LHN+uUe5SXex+DCWwZUlnQ==
X-IPAS-Result: =?us-ascii?q?A0ATAACGXHxnj4r/Ja1aHQEBAQEJARIBBQUBgX8IAQsBh?=
 =?us-ascii?q?BlDGS+McopnnQWBJQNWDwEBAQ9EBAEBhQeKdgImNAkOAQIEAQEBAQMCAwEBA?=
 =?us-ascii?q?QEBAQEBAQEBCwEBBQEBAQIBBwUUAQEBAQEBOQVJhgiGXSsLAUaBUIMBgmUDs?=
 =?us-ascii?q?EmBeTOBAd4zgW2BSAGNSXCEdycVBoFJRIEVgnIHb4FSgz6FdwSHbJ1wSIEhA?=
 =?us-ascii?q?1ksAVUTDQoLBwWBcwM4DAswFTWBJkQ5gkZpSTcCDQI1gh58giuEXIRHhFaFZ?=
 =?us-ascii?q?oIXhQBAAwsYDUgRLDcUGwY+bgeaZDyDboEOgikWAZNRkh+hA4QloUYaM6pTm?=
 =?us-ascii?q?HykR4RmgWc6gVszGggbFYMiUhkPjjq3XSUyPAIHCwEBAwmRdAEB?=
IronPort-Data: A9a23:bWCm6KKG8Tmq0sNoFE+RGpUlxSXFcZb7ZxGr2PjKsXjdYENS1DwGz
 WsYWGmEPvqPYzT9Kdp+PNm+9B8Pv5OAxtM2HQcd+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcoZsCCea/kr1WlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVrX0
 T/Oi5eHYgL9gmYqajh8B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRuukoPD8fwXG8M49m/c3+d/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTvOTLp3AqfUcAzN1gEGFxI6Ip1NpxHHh87
 NI8KGswaguq0rfeLLKTEoGAh+w5J8XteYdasXZ6wHSBVLAtQIvIROPB4towMDUY358VW62BI
 ZBENHw2N0Sojx5nYj/7DLo9lf20h332cBVTqUmeouw85G27IAlZjOC9a4SKIYTQLSlTtmK4g
 CHbwmmkOSEXJJ+z4gWawE+ogNaayEsXX6pJSeXnraQ16LGJ/UQRBR8cfV+6p+SpzE+0XpRUL
 El80i8nt7Qz8gqzQ8XwRQa1plaDpBcXX9cWGOo/gCmJy6zJ80OaC3ICQzppdtMrrok1SCYs2
 1vPmMnmbRRrsbuIWTeG/ayVhS29NDJTLmIYYyIACwwf7LHeTJoblBnDSJNnVaWylNCwQWi2y
 DGRpy94jLIW5SIW60ml1V7bo3Wyianncggo/zfOcEaltT59f6fwMuRE9mPnxfpHKY+YSHyIs
 34Fh9WS4Ygy4XelynTlrAIlQu3B2hqVDAAwl2KDCHXIythMx5JBVd0NiN2dDB41WirhRdMPS
 BSJ0e+2zMQMVEZGlYctP+qM5z0ClMAM7+jNWPHOdcZpaZNsbgKB9ywGTRfPhD60yBF9zftkZ
 8jznSOQ4ZAyVP4PIN2eGrZ17FPX7nplrY8ubcmhlk35jer2iIC9FuddbAHmgh8FAFOs+1iNr
 I0FaKNmOj1UUfb1ZWHM4JUPIFURZXk9DtaeliCkXrDrH+aSI0l4U6W56ep4I+RNxv0F/s+Wp
 SvVchEDlzLCaYjvdV7ihoZLNOi3Bc4XQLNSFXBEAGtELFB6Pd/ws/9EKMNuFVTlncQ6pcNJo
 zA+U53oKpxypv7voVzxsbGVQFReSSmW
IronPort-HdrOrdr: A9a23:94weBKpuS4PDr2VJMPvzHY4aV5oYeYIsimQD101hICG9vPb1qy
 nIpoV46faaslgssR0b8+xoW5PwIk80l6QV3WB5B97LNzUO01HGEGgN1+bf6gylMzHi9+JbyK
 dre7VzBZnNF1Rg5PyKhTVQa+xB/DFCm5rY4ts3CBxWPGVXV50=
X-Talos-CUID: =?us-ascii?q?9a23=3Af2nmUGj9qMlYa+Ol1mwLAYy5kDJufGH9i2n/EmG?=
 =?us-ascii?q?ED3tweqS7bV/Lxad/up87?=
X-Talos-MUID: 9a23:xIxyawmy+MryM3KdBJvldnpGFOEr/pmjVXs9nIVFl+K7Kh5NPzGk2WE=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.12,293,1728950400"; 
   d="scan'208";a="408367302"
Received: from rcdn-l-core-01.cisco.com ([173.37.255.138])
  by alln-iport-7.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 06 Jan 2025 22:45:05 +0000
Received: from fedora.cisco.com (unknown [10.188.112.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-01.cisco.com (Postfix) with ESMTPSA id E446F180002A2;
	Mon,  6 Jan 2025 22:45:03 +0000 (GMT)
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	aeasi@cisco.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH 1/3] scsi: fnic: Remove unnecessary else and unnecessary break in FDLS
Date: Mon,  6 Jan 2025 14:44:49 -0800
Message-ID: <20250106224451.3597-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.112.101, [10.188.112.101]
X-Outbound-Node: rcdn-l-core-01.cisco.com

Incorporate review comments from Martin:
    Remove unnecessary else and unnecessary break to fix warnings
    in the FDLS code.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fdls_disc.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 2534af2fff53..2513a82a8915 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -2776,23 +2776,19 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 			/*Retry Plogi again from the timer routine. */
 			tport->flags |= FNIC_FDLS_RETRY_FRAME;
 			return;
-		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-						 "PRLI returned ELS_LS_RJT from target: 0x%x",
-						 tgt_fcid);
-
-			fdls_tgt_logout(iport, tport);
-			fdls_delete_tport(iport, tport);
-			return;
 		}
-		break;
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+					 "PRLI returned ELS_LS_RJT from target: 0x%x",
+					 tgt_fcid);
 
+		fdls_tgt_logout(iport, tport);
+		fdls_delete_tport(iport, tport);
+		return;
 	default:
 		atomic64_inc(&iport->iport_stats.tport_prli_misc_rejects);
 		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "PRLI not accepted from target: 0x%x", tgt_fcid);
 		return;
-		break;
 	}
 
 	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-- 
2.47.1

