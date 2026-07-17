Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8393644AF
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 19:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784315441; cv=none; b=OuozvpQofvrnzhqB0rpBXPkrrvh0fPdrj1cLUr67pMg0Af8qFYBT6Lw4KU+FPPaJ250Q6VhAV9w2oc7o5kdApX3mwkbYCYgrH/h4dQpgkD3qAuKOdZqBA65dFVyqZLsiaxbK4isV+BFah71eqPwrh7awlzdjX4DVJpy/7qpIyZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784315441; c=relaxed/simple;
	bh=528WnLx/ere1/7IWtgIPJzlwyOQMYlZVAa6XHHCk8Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DIbbCcdev6EzEFbSuBiHe0j4zzU52fc1SfuDoPuLajrGLOzBrhxmU1SztvWimqJ4B+vXo61EmQLUKW6xhAKGq+1yO9FpFgaPy1vgVLwdg9F0iGv20cGARGWY61oAqmRzLhbIpv0Pyc/hMubeSFJFSD2mQGQuTHaiYosuSQbQn2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=artiphishell.com; spf=pass smtp.mailfrom=artiphishell.com; dkim=pass (2048-bit key) header.d=artiphishell.com header.i=@artiphishell.com header.b=GYHJswYz; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=artiphishell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=artiphishell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=artiphishell.com header.i=@artiphishell.com header.b="GYHJswYz"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cf27856f9cso23331285ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 12:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=artiphishell.com; s=google; t=1784315439; x=1784920239; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Uj3MUcaBKuvy3eHSqwcQWrEx9seDEbNfawJQjAU6jZQ=;
        b=GYHJswYzj/cQ4eAudhqxcYOrQo0lvAHHZzucz13riuYEiYRefQB7sUwdhmrC5PiRzF
         U33V6e8jZpvLOBbVtu5BGsh8OQyvWt3fppNdyVOkMKNv1Nw3ETDu9VydZJLRJN8FAekp
         kBgNg+9K9nEYOcIgo9jrJhcXaCKucW2qfjWleCUzNr02VmRxvIpVSpXwZzXwp/S5cZd5
         cRHnMU6y5kBJuvu8r9J2TTw5Fx9lLOJ6YuhYg9XsKci6k0qQTS3sU+A2Vy8GdUtnYmpH
         3YC1yKjuBs+mXxMAPTPULF1bkGmslkTqTtcR6qbnyUU33XHLWB7hDMUeb1lmVsV0WB93
         I6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784315439; x=1784920239;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uj3MUcaBKuvy3eHSqwcQWrEx9seDEbNfawJQjAU6jZQ=;
        b=mQyjjaVgEYcRu71/Qk5hO71MdSBZN09mGzbL2bUibkWvQxnBpUqmxUQdVQFSFG6XGP
         MAlXhCq0eFwYqWTGFAQNXOlWEqvKpqEm0mw9lp2NWN5lwVYAIj3Ks8Bb53FKHHcXLT9Z
         OWdmYrbsx0T5WARSpNM5ghBuCGvCljuj7IpD9qRbHzVzbmQcm1jjBD0q6uxgZEIAR1OH
         /x4qjRmGJBDGAWlw/JOt2S+uzMUzWxN9Y1yDM5ylcZ/00TP/v20jMM+V4VYJowo2LUpE
         2b96nRiSOlyWSGNBrVOpp9GVNgWgsMZVs4U7AjB0CG5NDJ4ZPeAr/SSssbplBBPZMRZI
         dPXg==
X-Gm-Message-State: AOJu0YxQf8TF+s+EcWspMXYdo5kbNv1Q745E6iTKQna4G53+opuEp+QT
	Ww0nBTejM0duwIV/ShbVmxAbGQCnC1kFyPGbVEdaKqlVGgKiLP3mL070s1rxUTv8amb6
X-Gm-Gg: AfdE7cm8hYyY+EwBRDDJd8YJavHXvdhzimgnQzM5XB3LxyCT9OE6yGvz3k+5ItMQbzF
	+Mk3FjJq+Iz7csc3eaF5810Z2rob0n9Sqp3RJlF3JiJ1D5WrSpAMQKZGZORhUcM3/2oCYeOnj3A
	v15U2Z3fgcqulcon/rjPzZAeV9f5BIR85ozYLWbWzy4mMaxMkhzpscGbcWG/DDao6Xro0Utsoau
	z+GJFzLpCaZO9CKSHPvw9G2DdfZ/OjlJmwL0pwWhamGYL7ccPF6T921gfeW3YHRSEKsAE7d1gMp
	8woqbxVbIYN1DjJVnE8ZmqvrUU7g3c45uY/DUNBC1vHDhXc4NcgS7HaQgVgfn8UmyLMw41JLjU/
	GiNzyBFbwbQxoz+T668jF1qOOZf6D59blpEvhdeOICG6YQ+QH7PZTBUK2b9h1bd5YEhK3
X-Received: by 2002:a17:90b:2fc5:b0:38e:2c8f:a01a with SMTP id 98e67ed59e1d1-38e4b4119c7mr4058083a91.11.1784315438759;
        Fri, 17 Jul 2026 12:10:38 -0700 (PDT)
Received: from nixos ([2001:579:62a8:47:e2cb:6b8:ea21:46f2])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31429f9d439sm11721406eec.5.2026.07.17.12.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 12:10:38 -0700 (PDT)
From: Jay Vadayath <jay@artiphishell.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jay Vadayath <jay@artiphishell.com>
Subject: [PATCH] scsi: sd: validate device-supplied mode sense lengths in cache_type_store
Date: Fri, 17 Jul 2026 12:10:21 -0700
Message-ID: <20260717191023.15011-1-jay@artiphishell.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A malicious/emulated USB mass storage device (or any SCSI target) can
return a MODE SENSE(6/10) response whose header_length plus
block_descriptor_length is >= the size of the on-stack 64-byte buffer.

cache_type_store() computed
	buffer_data = buffer + data.header_length + data.block_descriptor_length
and then dereferenced buffer_data[0] and buffer_data[2] without ever
checking that this offset still lies within buffer[]. With a reported
block_descriptor_length of 60 and a 4-byte MODE SENSE(6) header the
offset becomes 64 (== sizeof(buffer)), so buffer_data[0]/buffer_data[2]
read and write past the end of the stack buffer. The subsequent length
computation could also underflow and let buffer_data + len run past the
buffer when handed to scsi_mode_select().

KASAN report from an unprivileged user writing to the sysfs cache_type
attribute of a device backed by a raw-gadget mass storage emulator:

  BUG: KASAN: stack-out-of-bounds in cache_type_store+0x8ba/0x8f0
  Read of size 1 at addr ffff888003097c72 by task poc/57
  Call Trace:
   dump_stack_lvl+0x53/0x70
   print_report+0xce/0x610
   kasan_report+0xce/0x100
   cache_type_store+0x8ba/0x8f0
   kernfs_fop_write_iter+0x384/0x4f0
   vfs_write+0x5c7/0xe60
   ksys_write+0xf7/0x1c0
   do_syscall_64+0x61/0x480
   entry_SYSCALL_64_after_hwframe+0x76/0x7e

Reject responses whose mode page offset does not leave room for the
three caching-mode-page bytes we touch, and bound the length by the
space actually remaining in the buffer, mirroring the careful bounds
checking already done in sd_read_cache_type().

This bug was discovered by Artiphishell's vTriage pipeline, which
generated a userspace raw-gadget reproducer that reliably triggers the
KASAN report on an unpatched kernel. The fix below was drafted with the
Claude coding assistant; a userspace reproducer is available on
request.

Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Jay Vadayath <jay@artiphishell.com>

---
 drivers/scsi/sd.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -228,7 +228,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
 	static const char temp[] = "temporary ";
-	int len, ret;
+	int len, offset, ret;

 	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		/* no cache control on RBC devices; theoretically they
@@ -265,13 +265,22 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 		return count;
 	}

 	if (scsi_mode_sense(sdp, 0x08, 8, 0, buffer, sizeof(buffer), SD_TIMEOUT,
 			    sdkp->max_retries, &data, NULL))
 		return -EINVAL;
-	len = min_t(size_t, sizeof(buffer), data.length - data.header_length -
-		  data.block_descriptor_length);
-	buffer_data = buffer + data.header_length +
-		data.block_descriptor_length;
+
+	/*
+	 * The mode parameter header and block descriptor lengths are
+	 * supplied by the device and must not be trusted (e.g. a malicious
+	 * USB mass storage device).  Reject responses that would place the
+	 * caching mode page (of which we touch the first three bytes)
+	 * outside of the buffer to avoid an out-of-bounds access below.
+	 */
+	offset = data.header_length + data.block_descriptor_length;
+	if (offset + 3 > sizeof(buffer))
+		return -EINVAL;
+	len = min_t(size_t, sizeof(buffer) - offset, data.length - offset);
+	buffer_data = buffer + offset;
 	buffer_data[2] &= ~0x05;
 	buffer_data[2] |= wce << 2 | rcd;
 	sp = buffer_data[0] & 0x80 ? 1 : 0;
