Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1B73A0B31;
	Thu, 13 Aug 2026 08:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786610693; cv=none; b=LaFyqxdKQRAoye7FQfYcPJUnaUlVLjy2mo9CzvEF0BgF+eGlGL+R3G3XqG9nwq3JuBLSqtjnIDPN/5RlcE+LaLEDguRU7cAwO6TjsoYd6Qa2Do62Ie4SLal6BKBa1xuw+lpv8suTUuPHZCdvq0AxPhTgp8MYIqYPgLC+A2YG1+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786610693; c=relaxed/simple;
	bh=s2YcNA3pSwZVRLtP7sx7m5aGigPGHbMlBHx7GY3qLd4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Y1Qy0ebh9wu9XOCPR/DCmOA2fdIGkxfuS8YEokzvLyz8edDEB91jx7AZZPvaCBV4cUdmbABOWoZEvq6y6dq+cbPvcBJMTKSg0KNCrNYPhaRV3QRrZVtZiAinF6wc2ASJ0sib8eLzcvJS24YQfrfkd3lmIbXTJG6mpM70Q33UY5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=Uv6atdtP; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="Uv6atdtP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1786610691; x=1818146691;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=03SX7fNUva996hdLSsqy/qFlfniBH89rSrd5zkxNHfs=;
  b=Uv6atdtP47MjlpKDhJqpWpksw/I319Yjo/katYjIVS9zemSbCJZ3duqO
   EWPBJ/vGXLnUKim2qcjBCZTfn/nEe8rLNI7AoxlWsXcGVpQhKgFjs8iFq
   BBpbPnPZAPeM763nRO6H+EkoaMn4DLqAM5qT8JVgAH8l6WP0lm/lOzcwJ
   PwSZ8vROHrQRtFVLI+M7OCT1HtgVuXondKxhKvTqvg76ZpPksybrUpM2R
   uSJi4BqsrOz4uyfKngGvPwrk4KT0uwBWL+gVeq5xqv//GcrVTiV5wu87J
   R8QS5y5Rs11M/KT+AL7djQWHm5vsaO7q7jkURdppgq6Vr3M2XgDLJjGwu
   Q==;
X-CSE-ConnectionGUID: VDArIwv0Rg+iRDPALpKSww==
X-CSE-MsgGUID: 4Su1cxHVSTS1cmnQU/mlYw==
X-IronPort-AV: E=Sophos;i="6.25,221,1779148800"; 
   d="scan'208";a="25364058"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 08:44:48 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:27488]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.54.183:2525] with esmtp (Farcaster)
 id 7b48b8dc-376f-4c2d-b788-44b780cb2652; Thu, 13 Aug 2026 08:44:48 +0000 (UTC)
X-Farcaster-Flow-ID: 7b48b8dc-376f-4c2d-b788-44b780cb2652
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 13 Aug 2026 08:44:48 +0000
Received: from dev-dsk-jaspwise-1b-5558f826.eu-west-1.amazon.com
 (10.13.227.24) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45; Thu, 13 Aug 2026
 08:44:46 +0000
From: Jasper Wise <jaspwise@amazon.co.uk>
To: <mst@redhat.com>, <jasowangio@gmail.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <pbonzini@redhat.com>, <stefanha@redhat.com>, <eperezma@redhat.com>,
	<virtualization@lists.linux.dev>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nh-open-source@amazon.com>
Subject: [PATCH] scsi: virtio_scsi: set DRIVER_OK before registering the SCSI host
Date: Thu, 13 Aug 2026 08:44:05 +0000
Message-ID: <20260813084405.610322-1-jaspwise@amazon.co.uk>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D036UWC001.ant.amazon.com (10.13.139.233) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

virtscsi_probe() registers the SCSI host, and scsi_add_host() adds the
class device carrying the host's write-only "scan" attribute. A write to it
reaches scsi_scan_host_selected(), which submits INQUIRY commands on a
request virtqueue, notifying the device.

virtscsi_probe() calls virtio_device_ready() only after scsi_add_host() has
returned, by which point that attribute is already writable. The virtio
spec is explicit about that ordering in 3.1 Device Initialization:
  |  The driver MUST NOT send any buffer available notifications to the
  |  device before setting DRIVER_OK.

Set DRIVER_OK before registering the host, as done for the same reason in
commit f5866db64f34 ("virtio_console: enable VQs early") and commit
1d774589f924 ("i2c: virtio: mark device ready before registering the
adapter"). scsi_add_host() can fail and now runs with DRIVER_OK set, so
reset the device on that path using the driver's existing
virtscsi_remove_vqs() helper; the core does not reset it when probe fails.

Fixes: 4fe74b1cb051 ("[SCSI] virtio-scsi: SCSI driver for QEMU based virtual machines")
Signed-off-by: Jasper Wise <jaspwise@amazon.co.uk>
---
 drivers/scsi/virtio_scsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 5fdaa71f0652..b394de0335d8 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -976,12 +976,12 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	}
 #endif
 
+	virtio_device_ready(vdev);
+
 	err = scsi_add_host(shost, &vdev->dev);
 	if (err)
 		goto scsi_add_host_failed;
 
-	virtio_device_ready(vdev);
-
 	for (int i = 0; i < VIRTIO_SCSI_EVENT_LEN; i++)
 		INIT_WORK(&vscsi->event_list[i].work, virtscsi_handle_event);
 
@@ -991,7 +991,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	return 0;
 
 scsi_add_host_failed:
-	vdev->config->del_vqs(vdev);
+	virtscsi_remove_vqs(vdev);
 virtscsi_init_failed:
 	scsi_host_put(shost);
 	return err;

base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
2.50.1

