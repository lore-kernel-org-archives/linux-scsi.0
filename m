Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBE13DA7F8
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 22:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784326491; cv=none; b=FjRt71gghp0uKHx5pevC9rvSebWNKAHYPVktjyASM+vM/bl+ZqKyvCwRhptr3Dj/XB66Fed3Br8/6F5or47kJUi9nZl44QaAiSpi8b+K3KLc7drCm3RbiEsYqhsukttpEDQNGosvB9Fk7x+FwggOm3qvap8XZ9QRvpDBkR8+8k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784326491; c=relaxed/simple;
	bh=ojjBIeEpbZdB//W3yyhnfC5gmiG+SYw9tbeCHMZ8rD8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IH1UJa9kXPWzEnOcZ8wUKqjY7sgz+ETcY5/NUj3+D2HgmVJB0OqzPm7lKQIZpFhV6MtFy4HmdFkbE79awxzskdTRCgZKXRkc0vFj6tVYeqIkk18NdOHdsZ6/giqnAX7KDgPGmGffE+ITDH7TMcNVKaAgETxnKjKRH/zW6aU8N8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=artiphishell.com; spf=pass smtp.mailfrom=artiphishell.com; dkim=pass (2048-bit key) header.d=artiphishell.com header.i=@artiphishell.com header.b=xSbF43mL; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=artiphishell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=artiphishell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=artiphishell.com header.i=@artiphishell.com header.b="xSbF43mL"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38e4beb7cc0so1059281a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=artiphishell.com; s=google; t=1784326489; x=1784931289; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oWc9+glHcVNgc+bm+bHKWgK4aRGh53J/70p87ra6mXQ=;
        b=xSbF43mLOeeE546MimkIB8zdJK82fQ4kYrE3wU+dq5melQlEV7JZDqD8flwKW2Q/ih
         ncUA89PkUjcXR5/Pgs7w+xLGg3F/Weypf7ksbVQLntQ7DpZgzUa3kG4C+w/Xvu3mMS+6
         yxLJ3wARBh9tzCXkNBdfL57sq35arAIp8KibNJDc36zO4XlmTNs3AfCg7hC93bFvodxa
         1Ig0CkRu3d6YIL+rwfyFuh5QkREfxpCEo/SfnfxsR0xGWhGoNSuDlHeVaoNbFygCi2kN
         +2LEUYI29fBLnXRL966egHkIelSO5wedW1muQ7pWEMKLxnZrc2xQgo7GiGjUnsXqzTjp
         y0qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784326489; x=1784931289;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oWc9+glHcVNgc+bm+bHKWgK4aRGh53J/70p87ra6mXQ=;
        b=pC/LH30cgn8/rM7CdaKJrLKLBRa5NT6Xl1lpL3WzBMGhShz1z/OT6ApcXRrijJWBWe
         7SBBB4eoXqRSPt8VNcnHhUpvrdOWsvAsOu+wXWrL5qlkjHNCFGmI8nIU6Mrz4zXmIvZ/
         e54uqlB/ZbxMqAQxKcFAROWGcMCuW3grDDJfgOpLwXThL23xODs3ghkTP5e5TV5crlI2
         Bre6le7SbbO6S68uxYLiY5YIG2nz6vUqWRjVZAKSs64tDBpgD5x4p0SDDxB3ni73Qz2P
         o4IhBsUIibMAiwNNGc4PoBHh46FJPfpAtVLl2aCxt9Zr7vKrGLtUbJLBZgQcKxgzsr9r
         PJ5g==
X-Gm-Message-State: AOJu0YwLb9/If091WpSjy7RCxnFWrj209bvWYGMyXknv40SSqf8q4JX3
	UE42PCn6Rwd+PbVez2aqvzPb1/KkQkPSSjMUD63Io9TBxWAxrU37flFxlm21yNvh5eKk
X-Gm-Gg: AfdE7cl7hW6hVvTUsdWn/q/9CqxUvD7z2Xx7kREZsnT4FCrmnUFtZPHRWGASwnA/ktY
	CJ/jrGguxADXnYbeXNW3/GjIg00nZq/Lz/RwVe/3rfBLYVRwGJD087qeBWF3p7vP1DrEkKTYxnK
	I5iWDPbqfYRejQKjB67DXii4BIq+kpEMRldgn5gOXOU/9PMTq4sl7U1qiEEv5f7ecfs/W/QTRAD
	2tYcbY/c3ptfboDAlygA7O2kM60j76GFMElU3op76SLxO7uJ/dh8uq4fqsyePAznljFCWND0NAK
	p+h+9ZvPFaDjEpLN0iYehQO8wotZ8En8uHnEOZwL5hjXiaNQPEbvca77N7X1jZYcGzVUQvPedya
	yrfH/QK6qnNnzsRHRrEpbkjPcLoUYrcV+fB1qMp9NrE7tnn92kanes5KZODpuRF/UUOouhA==
X-Received: by 2002:a17:90b:590f:b0:380:105f:8ffd with SMTP id 98e67ed59e1d1-38e4b46c8a6mr4857956a91.16.1784326488696;
        Fri, 17 Jul 2026 15:14:48 -0700 (PDT)
Received: from nixos ([2001:579:62a8:47:d0f5:3653:252e:1041])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31429cf22b3sm11051399eec.0.2026.07.17.15.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 15:14:48 -0700 (PDT)
From: Jay Vadayath <jay@artiphishell.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jay Vadayath <jay@artiphishell.com>
Subject: [PATCH] scsi: sd: bound MODE SENSE offset in sd_read_app_tag_own()
Date: Fri, 17 Jul 2026 15:14:38 -0700
Message-ID: <20260717221442.57163-1-jay@artiphishell.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sd_read_app_tag_own() issues a MODE SENSE(10) against the target and
then indexes into the returned buffer at
	offset = data.header_length + data.block_descriptor_length;
buffer[offset] and buffer[offset + 4]. data.block_descriptor_length is
copied verbatim from the untrusted device response and can be as large
as 65535, so with a hostile response the offset can point well past the
36-byte SD_BUF_SIZE buffer the caller passes in, producing a
slab-out-of-bounds read.

KASAN report from an emulated USB mass storage device (raw-gadget +
dummy_hcd) returning a MODE SENSE(10) response with
block_descriptor_length = 600:

  BUG: KASAN: slab-out-of-bounds in sd_revalidate_disk+0x863f/0x8940
  Read of size 1 at addr ffff88800634de60 by task kworker/u8:0/12
  Call Trace:
   dump_stack_lvl+0x64/0x80
   print_report+0xce/0x620
   kasan_report+0xec/0x120
   sd_revalidate_disk+0x863f/0x8940
   sd_probe+0x79f/0xf20
   really_probe+0x1c8/0x950
   __driver_probe_device+0x1a5/0x430
   driver_probe_device+0x45/0xd0
   __device_attach_driver+0x156/0x230
   bus_for_each_drv+0x10f/0x190
   __device_attach+0x18e/0x3b0
   device_initial_probe+0x78/0xa0
   bus_probe_device+0x57/0x130

Reject responses whose mode page offset does not leave room for the
five bytes of the ATO mode page that this function subsequently
touches, and log the rejection.

This bug was discovered by Artiphishell's vTriage pipeline, which
generated a userspace raw-gadget reproducer that reliably triggers the
KASAN report on an unpatched kernel. The fix below was drafted with the
Claude coding assistant; a userspace reproducer is available on
request.

Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Jay Vadayath <jay@artiphishell.com>

---
 drivers/scsi/sd.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3366,6 +3366,18 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 	}

 	offset = data.header_length + data.block_descriptor_length;
+
+	/*
+	 * block_descriptor_length is taken verbatim from the (untrusted)
+	 * device response and can be as large as 65535, so the computed
+	 * offset may point well past the SD_BUF_SIZE buffer that only holds
+	 * the 36 bytes we asked for.  Validate it before dereferencing to
+	 * avoid a slab out-of-bounds read.
+	 */
+	if (offset < 0 || offset + 5 >= 36) {
+		sd_first_printk(KERN_ERR, sdkp, "ATO mode page too long\n");
+		return;
+	}

 	if ((buffer[offset] & 0x3f) != 0x0a) {
 		sd_first_printk(KERN_ERR, sdkp, "ATO Got wrong page\n");
