Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996842;
	b=mFV3FqLcuyNRV6IdO8BeoVcuetpIgfwnFuijnce3QnbKk1aoWJCKBdm9GDAGgmOG53ki
	 +PZABHZJix8gVYwjVtJScWiOvGCy8LYf4XFPU6NshWMKLvLUXS2XjFvhNdc6n5pxB/Bo0
	 3apxqivBFMAqnDWBsUm75VJKlWbyj32MJlLtRUap/Ej07mtK3DSvMM/YCmmWRLHQuQRIK
	 iA/hKl1LjNAQ0XCAja78I0dJkZmJH3er9BszWlI7EiqwrJ3pbMqrTqew/6fPqEzfxK8+u
	 SIODSmQW5SSSGy4jbB8pBiM6w89A3QGtp39RyUpXMVs6XV0TfB09YtRFYBOs9ROGhtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996842;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=DbSqxVGv1kq+jrrNs93XJvoWxUY04nGrYsJzXNYq8Qw=;
	b=WOfNUyRNpcWmBs5KO3bMMnNLlEgqqmKn7PXOQCE+Lz6Wqzpl7Ma4t+1NP5Bh4H2dThZk
	 N0rV3b/5sDNflHHU3pDpKJoOYz31tLMvv05V0j75XDhg8xiydFdJMaFa8IihYG8/IfKic
	 7VlTpVR76VWk847Y4ZuUAQOjC3SsZEPEoJ/vR2sEwjw7MqrB9ywOe96yQUSaBXeWfW//Z
	 mEJmqTGT9KRAaqPHQgzTOO7dHbQ1QTlBzAfwWsG0DJuz8bCTP0KiU/3Cavkl9UBabrnne
	 estfJsa9GHpS0fHv7Tqc1JRB2TF90xBVI9kGUJBf+UANilz25aWIOuz0qtgWUWvALMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=VO8KJrv9;
	arc=none smtp.remote-ip=209.85.216.100
Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B495606A32A
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:14:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B495606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=VO8KJrv9
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3adac5c10e3so452217a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:14:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996841; x=1795601641;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DbSqxVGv1kq+jrrNs93XJvoWxUY04nGrYsJzXNYq8Qw=;
        b=Gxze5uvQALA/CsGCApoAQnI4mmOHQA0nsrtnyxq1BxKosPeBdqrCk2jNrdDQNgXYuF
         aDAYFDNxKQaMEdQdFo2QbDLy4kVa6j/D/A7vzyc2DrCY8jUyVhWovjni6pPjF77h1GXk
         fN/AoAGUQdwA4jcx1f76BK/QcpjRQnF4iH2qVC1y4ZLlbePMo3tWbYpEfAPlmhhSfU1f
         vrjA/8guDVlZMrCPmCxky+YfPfChC+4BKg3e85etju7bjX08DKJ/sm/yP/3bZUzzt+7X
         zDZ+Iu+SzqfBOVzBAeRJHlKh7sDYRiqgEMPP41ZhqZsq+TV8H9LvKm3x5px7g0o1l1PD
         1ySA==
X-Gm-Message-State: APuU4Z9VvYMpQvdqlpA0aOQOWrbT2hImd1WwpqO5AnV9QZ3YU94h3Fky
	EoFnLF198Gu01h/DuB65NYqXd0C5sr2PnGsBCGGI/TnQDne/0GoEZCULs5ienS2EZXsbIl7dfXG
	acMrDlm1aYGa6Sp5J6+22Dt74MA0wCvXi1JHStWlb/978p2HibVEvtEj0+KAAswatuyh6S3KBy4
	/3J2Of3d1lunAEUZQL12bP3SZBP4Fk532K/gSvi78tFFBiDehtHLj4YW8yMuDS/MO3Ac0JYZzC4
	JW5fUgSxbVyVENNrh0PXFcizhJspR7y4I0=
X-Gm-Gg: AZFdTZcF3Heg1Jm54fLKc2+4fXbbcAikPpaNZvEVmOnM2AtGpxmqpoZV+owaijmOtV1
	S4gkiUiPqDAqKQR+bfiFw1bkpOzsJInr3WmAA89lUF819OBw6aCsUIb8HcKH/rNO6OgbW1mjTye
	1CpjjuhybeQE4lImjwVzspUsUpuw6G4IIfxDpTazqJycCGCdLcHEe2bcWFTi6z2ubYAZTyvDWxq
	V9YUhgNONx0+HfrKqNVporzaLubEoQgmFJI7oSWmY7Vl00gJHBvxjU2Q/26ZtnNDLZsySSGk5hv
	j60ci/vu6Lc/eK2isXtzuqDvn9M7oQ6SP/uesmAXlMGcRfFfOtJm/Xq/AKlRMHQArOjgipoeW7l
	81EIWg0COP/L9FL0O1R36TWWGiQ4d/IDXgt2puQxPfKCzVSWHu1FBXk+vKfZs2EzYDFdWcBG+6l
	syjamjKX0iGaFwkqy+wKV+8JKCRe9eaWU3mr3nsyntphDeue0/w2t5fw==
X-Received: by 2002:a17:90b:3f4d:b0:3b3:8094:3228 with SMTP id 98e67ed59e1d1-3b3d07597b4mr2037969a91.14.1794996840961;
        Wed, 18 Nov 2026 02:14:00 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d4373b48sm601273a91.4.2026.11.18.02.14.00
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:14:00 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b08aee6b3eso750008a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996839; x=1795601639; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=DbSqxVGv1kq+jrrNs93XJvoWxUY04nGrYsJzXNYq8Qw=;
        b=VO8KJrv9EfWIa973lqfUA0T4nofOqp/TkCewfYpYY4gcjwx0sHhIexurbAHCDuhdHv
         KUyrcf+sDHWvsaDRgwXcaEvASIy5Axwx9XHXOPiN8DC2rxfE8DfJ5FqrfGz14wCRfstA
         lFK90kNeMNZaTATOLhOOUenvXCb2B1Q/QS5/M=
X-Received: by 2002:a17:90b:448f:b0:3ac:9c37:942e with SMTP id 98e67ed59e1d1-3b3d07aba04mr2291314a91.49.1794996838923;
        Wed, 18 Nov 2026 02:13:58 -0800 (PST)
X-Received: by 2002:a17:90b:448f:b0:3ac:9c37:942e with SMTP id 98e67ed59e1d1-3b3d07aba04mr2291282a91.49.1794996838384;
        Wed, 18 Nov 2026 02:13:58 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.13.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:57 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	thenzl@redhat.com,
	mgandhi@redhat.com,
	loberman@redhat.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 32/37] scsi: mpt3sas: Fix out-of-bounds bit operation in _scsih_check_topo_delete_events
Date: Wed, 18 Nov 2026 01:56:41 -0800
Message-Id: <1794995806-5835-33-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailer: git-send-email 2.4.3
In-Reply-To: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

When find_first_bit() returns a value >= MaxDevHandle (no bit set), the
loop called test_and_clear_bit() with the out-of-range index. Break out
immediately when the returned position is >= MaxDevHandle.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 64de88183f8d..b697250bed61 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5016,8 +5016,9 @@ _scsih_check_topo_delete_events(struct MPT3SAS_ADAPTER *ioc,
 		do {
 			handle = find_first_bit(ioc->blocking_handles,
 			    ioc->facts.MaxDevHandle);
-			if (handle < ioc->facts.MaxDevHandle)
-				_scsih_block_io_device(ioc, handle);
+			if (handle >= ioc->facts.MaxDevHandle)
+				break;
+			_scsih_block_io_device(ioc, handle);
 		} while (test_and_clear_bit(handle, ioc->blocking_handles));
 	} else if (event_data->ExpStatus == MPI2_EVENT_SAS_TOPO_ES_RESPONDING)
 		_scsih_block_io_to_children_attached_directly(ioc, event_data);
-- 
2.53.0

