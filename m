Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794303104;
	b=oKAI+P54qY+RO2XHpSZJNeWxT7311TimC6if79sYJI8NqstLGqm2OnPILZeLKtLFBI7j
	 yB7/Y18O/HtBvmZz+/8WK+ptTmYs6FWe92sEeCD7YGo4r8W6yLzGmlI9uZWEmiaLokkL1
	 hNAcEXYH1UlVw9rjAD2L3Ma0udMDYd7v9/+x0Jfja8ZBBS3/qgrxEJ9f06DnyQ7JhimYT
	 lxKPuQvhu3w8KinVYmPXVaYppPWVsnXqFgZDpgidSxJkrfj3JkP/ceXgM78HBLiHJoSYi
	 BVipcTB/xnFspaFLGrZjbe/8tXN2/VWR1h8u4TWhwpCMGj5i+8RJqGDsGspocx/Zr1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794303104;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=70d5HP/NDskHf8kArC44fYJ/2R1MLgLSjk60RYC7GPQ=;
	b=tTpBUbkUKvAio+wxdiPLj/ui4rykpMiiSK7z1LqacWbBYAWBDtU4oKpn45njCyta6e0w
	 GT512a4CkfStijqWNqc/JPltgGFsMPXUV+GopUuiALU/P+5vUVpcgD4w2wrzZBrUaIbJ8
	 iNpp+3hWSrsaulC7rPFmcANgy/1+7zDm2GQEpZ+cdTE+q/mUTorsimEvIcx3uyWJfBDxS
	 vskIgee5D7Dh4mUfeQAI7mFudeGDYlbvbulg88mmJlkPnLTuUkigVp6xxDWlpk4siJgJI
	 riUqMAOxOSdjjkbbeV35grDUUMsO1NdikPG4SqrvRmjqZmtQVts+2/8ENZ+VXjUzF1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m6VpWtDm;
	arc=none smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5180E606CF8C
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 09:31:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5180E606CF8C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m6VpWtDm
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-36e99cf7bb3so2980780eec.0
        for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 01:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794303103; x=1794907903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=70d5HP/NDskHf8kArC44fYJ/2R1MLgLSjk60RYC7GPQ=;
        b=m6VpWtDmn0Dldk5emvFKnESyohulG8uw0ZwPMGdM/9S9v9cGrlFeN9gVlckf0Mv0qd
         3fEteFvJtcrNghTloBDMtkBU/VUpnBYwWJGrWgbJ0TaRfH1Gh067jvJyvnab4B+wgVrs
         59hh1V5259n5V2cFrmtphIhIRlYE7Ju3zRc+8t9Sy3bmJzvV6sEoFD3SH9SROk5LFspc
         qIRJ4gTKCCniqI0K3QDpfIEI87CwGTcMfHt8fp+LwWdqE+Ip5GlYa+1E6hy1pFyOGnfE
         VUwYg7oOCMTKdy4QI6YD6tLww1NgQkM2GoW7dN5f8M0DqdEBrD9z/jv8huYgv9A/vJbT
         Nm7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794303103; x=1794907903;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=70d5HP/NDskHf8kArC44fYJ/2R1MLgLSjk60RYC7GPQ=;
        b=rEp8243FBVeLSbMhtEaSmRXWGfGqpGu4XrwbVFtxaWPF7iM59qydlvpnYJ71TYZ9i5
         ig7iKwFWCHHYnKlyoF6vcp12UP+4Yte7ywA6LD/9KZtlAh1Q/xcsgwsYcBW1TRAGDKw/
         pwJeefupdBRZHwQsE9k3Voavdnn+MoQHixCh7y7EP1kAkhAvpG9t0Im/6cnVkwS6os+X
         l8SLYI41+1YI7jTLjPuqMY+y+gsvi4UYOA5g65J8kxV53Ez21ZnaBywC1DVGJyHBNXdd
         4CUKV+zb4kjNtv1vOTip8AdcnlokmW96Pnka+tpkT53a4cdz+g6mP8ZFc7nB+BMGUoXM
         1VmQ==
X-Gm-Message-State: APuU4Z9PqP7wP8UnlMXkXSA0OefI25Au9rxRAe6+qv/oeXBMBCqPOaLI
	QOCJ9wxch8wb21f5VLAq0C6FfzcRGeiWmmkT0wK27ksl8BlNCU4UsLla
X-Gm-Gg: AYBFou1EIpI9yXvgX3zOtRnIOCz605CP+XbG90PfTUyxwJcFC+eqz/d8lR2D8tj5fox
	+q3w8tzLOUClsQ21XScfJvVyG0RuIbHehs67sqBkAIjnUTfO9zFaks3pODHD+82EAb5cBXitnNd
	OseaH/WL/RLm5rWWvfTR/1yhamkY+VVsUAKW7HwhrqGIqZP1IbMnedDIRHu+0+ck4MPqRjqTGrm
	czg6Z2Z+V521b/iX58Lw+neZSNTU4SRdND2LGYHKZAum3HjwELyltg/AkCotQJGEbVTifn+XcOK
	I0wrOn9DMK63Cz9qB/WDthX7huyl0IaSmIaejSMEv07Z8ZMz6ElQ6XUCkU0O7MkXmIv63oE03Yu
	Nc9+fvHXnY0BMX6MhmPmGPdHHAaKNhLvs6xetiFWSZ9qTwp0Q43nT+bI4bax+u2wVxKDiX+WuRM
	USzR/U/JAltWxV5IRAtzWudIzETZh1I/Dhi+VsR/WP9Vo8wLhPjcpDATZ+BgZduJtm7/j7kKzhS
	rw30ja8UGmv+H6WfWVhA3lqOkb0eMljUQ4RSEc1PR2vscJuDof9mHq6V4JfwI82t2nyXNrJoN+Y
	QCD3sXNzqGOd99lQrz8hCd+LsjHLh4zUoQukJ5q0pX+sh7mdY3qC2QlJJdw=
X-Received: by 2002:a05:7300:da01:b0:351:29c8:643 with SMTP id 5a478bee46e88-3751f46823emr2583654eec.18.1794303103003;
        Tue, 10 Nov 2026 01:31:43 -0800 (PST)
Received: from homik.search.charter.net ([2603:8002:ad40:56f0:140f:bba5:1d89:57e3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3751fe3261csm4840148eec.4.2026.11.10.01.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 01:31:42 -0800 (PST)
From: Mariia Nikitash <nikitash.mariiaw@gmail.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	morbo@google.com,
	justinstitt@google.com,
	kees@kernel.org,
	linux-hardening@vger.kernel.org,
	Mariia Nikitash <nikitash.mariiaw@gmail.com>
Subject: [PATCH] scsi: target: iscsi: Replace strlcat() with snprintf()
Date: Tue, 10 Nov 2026 01:31:37 -0800
Message-ID: <20261110093137.37744-1-nikitash.mariiaw@gmail.com>
X-Mailer: git-send-email 2.43.0
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

In preparation for removing the deprecated strlcat() API[1], replace
the strlcat() call with snprintf() to construct the AuthMethod value
directly from param->value.

Since buf1 contains unmodified copy of param->value, formatting
original value and suffix together preserves the NUL-terminated
output, including partial or omitted ",None" suffixes when the
256-byte buffer is too small.

Link: https://github.com/KSPP/linux/issues/370 [1]
Signed-off-by: Mariia Nikitash <nikitash.mariiaw@gmail.com>
---
 drivers/target/iscsi/iscsi_target_tpg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 99772364c88e..aad82a37538f 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -624,7 +624,7 @@ int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authentication)
 		none = strstr(buf1, NONE);
 		if (none)
 			goto out;
-		strlcat(buf1, "," NONE, sizeof(buf1));
+		snprintf(buf1, sizeof(buf1), "%s," NONE, param->value);
 		if (iscsi_update_param_value(param, buf1) < 0)
 			return -EINVAL;
 	}
-- 
2.43.0

