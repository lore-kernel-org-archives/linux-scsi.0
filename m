Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926796;
	b=T5VAHxNxuH9VykD5A1MEwNy+OYlZd+nMlB0opBi09UNr60LHNJezc1SVX66g74lL/3W/
	 qtD5qz+sbHuVSN0nfj6AltYaP1JcJzh4tIyzHlITtmjTA7Ci3h65JqpmcU4LlE9cn2i31
	 ShD6UeyYychu4Q4n5tjljSxyXonTcXNen1D2mAtBCoF/sc0HKKnIY++KJ8FWSkoOaC+K4
	 5PXKDcyxgqtQt94asWGN9C1qIsVLsjScZlhnMUQX2A9+ycBeIznYa9Qf0FDS8yDGeh+s+
	 JIJG2m62sL/XmpbDKq8gwf7niejE99ChzssnFd1F1MXwjHRBF5c5JlZJgeN+thN5NfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926796;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=eZflmuxCz3/oyHmtYXQTRIYFDIEaj/wtsw8S3v58x8Q=;
	b=T45muSNcHwZ/OgYi8GUG2G/VDNLRt3RZvbYNg7JkDVx91wKMQxXvMV1MeAuMF5XoaAxm
	 ++Uo6B9lHvUw/TXeiNXD8Q3/PD0LRzmnbzeamfnFNDSAnm6w1swvzEW+4EvD5HTvbHvoT
	 l7XSwn3FCm5zXXFRUlFF5MivNVHHxOif2Tg6lxCd+ppdSJrMGVlrILnvOaOWsXXJQBXFY
	 W2wLCsGboIUbRVYWbg2FOygCh4lzMVKkdtlziRh+6hDJtzN+C754i9p9LXt9UhJkC5w75
	 +lmgurTJZmiOGyMw8tnn/Zf7xkYIvXMJXCvjnBL1jeeBktiZ8RLqAh46BzQ3dNRQhZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=eeiEllNR;
	arc=none smtp.remote-ip=209.85.216.100
Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9548B606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:59:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9548B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=eeiEllNR
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3acb11973c3so108204a91.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926795; x=1794531595;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eZflmuxCz3/oyHmtYXQTRIYFDIEaj/wtsw8S3v58x8Q=;
        b=sXGeIanFH4NJsrgH25U1MU+LEGgJgO6RezCDfY0/pPQzzN4Uf1tdDZGbGY400sAlQZ
         4+6RF4crEig8vlh5iYVSY0OmqqENChNv7P3d57zeBDSKIz7VTQkJLY4AbMDriDCuuI7t
         F4+jrcS1NzgkX+tfyUdE/aH3n8juBYH69B+C1faSAut8JC0h+/3wmysWMLfv/7z1UnL8
         J2DLLssJ4noZkmGOou1ktEJYBYEMWTr2H52YgISi7W4JgWKRk7Pc8cxxxNCoysp5K5i6
         7aCPneVDzMokbQFZB6AnFbaVMzhaIuhnH39Qgnjp9TEwdiLOoMZLnhgwyra5wBvKxP0t
         3N7Q==
X-Gm-Message-State: APuU4Z+K6hHKfe+1/DneJXFLVaA8K85bAWhE3M/cWq6437ezpFCRpAGe
	TMLp6NWWIq5HbDLxOx++pyLgiV2sgIBAZ/AdOPZML8tQi/RH6vPkliB8ffRKjTpTYx3pqB7s4mI
	qpCI4OuIgFwxkVJyS+hsXg+1gCavQfqsq+AmiZBOo1IMykz1oMOx3n01NXWJ2UWsi9UTHR4ZGnE
	CO7oZaNt+z6e5T453ixylh6LQyjuo7jvK4pqhASknGjdv+xxdI0umJFEbpS84W4SFxVKTlkKTwX
	ZOmaeFv/vV1bFBU2pHLd3of3OfeTl+s7Ig=
X-Gm-Gg: AYBFou1upUnNk5LT64uHN4GaSglHaW5Q9r1n6UTDtA+lvq3P4yKEBpFFNpM2RPg3a1x
	7nLQnwDpyNLbu8Y0/AztlM5rTm546OWPxYlbkGpndGMwq9oFKlmdTa9P9HoKt0lDgfFFus9RTjN
	W0xJE8INcN6+rW7IdNsx/KbkBhqlqG4YWj4oQWAmsZ0UvgmuiR+QhAKy0F7K6GMXihsfB3DxGkX
	X5n+hHveyPVJG+DA5UusBO/ULhvPF9lLiWy5HZQGHm9IJZ5WDdS58fwZ7awgI7i+yVckR0iHxfW
	BIXb68SBROaua7HSl6UJ8/1KkWUWptRDYzWiKGVqUkN4bp9299aT7C6DL0GK9XBz/nryoE+Awn8
	ZwtzaXyD6uMEWiNvvYUUQ/g4AKwWXNv9dYT+/y40qaQmnuxnWGV5R4hdIwgbsP3keCx2U/2UeLE
	dM0g0SrLdWTwx7BHgziK+gg1PHec+qLIv+BXNhKRgu2eTgC2v6kRyKrg==
X-Received: by 2002:a17:90b:52cf:b0:3b0:ae41:2706 with SMTP id 98e67ed59e1d1-3b0db5f60efmr903472a91.4.1793926795019;
        Thu, 05 Nov 2026 16:59:55 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b096bd2672sm1911836a91.2.2026.11.05.16.59.54
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:55 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ed276af91dso1814295ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926793; x=1794531593; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=eZflmuxCz3/oyHmtYXQTRIYFDIEaj/wtsw8S3v58x8Q=;
        b=eeiEllNRn/tcJTeyoUQdSx0jzFIFwp8Ut1yrsAzZsKvBl28B2kX79MXHQX28hZb+0v
         x7hfJP728UL3ILyFLcq3dqokWlMxYtWohsocQCQE7W6R6R9bbv1SsPuVY3R1B9Px31Mc
         PdBKnOLu5bytYF0iq9sdf/wicj+TEFMgkW4u8=
X-Received: by 2002:a17:902:ce90:b0:2ed:1b02:f6f2 with SMTP id d9443c01a7336-2ed412fc84dmr13904255ad.6.1793926793375;
        Thu, 05 Nov 2026 16:59:53 -0800 (PST)
X-Received: by 2002:a17:902:ce90:b0:2ed:1b02:f6f2 with SMTP id d9443c01a7336-2ed412fc84dmr13904085ad.6.1793926792862;
        Thu, 05 Nov 2026 16:59:52 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.59.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:52 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 32/37] scsi: mpt3sas: Fix out-of-bounds bit operation in _scsih_check_topo_delete_events
Date: Thu,  5 Nov 2026 16:42:47 -0800
Message-Id: <1793925772-1303-33-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailer: git-send-email 2.4.3
In-Reply-To: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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
index df5f16db8f48..4585b666d4bb 100644
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

