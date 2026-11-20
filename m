Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186740;
	b=TxxqTsFo/kD+bbIVYXfYWIroKe3DZmZPjIMQ/VDahyATNHTHvPq3YbH3xXUGTAknBxJy
	 fP5JfNBHVpByEcoGDN6lc2H4Fb0XuIeEYR/BVUCcvAkib9w3gGsTyhk/4sI1xgAs3CvdZ
	 oTUjexu4MBkByBlX40pOpSMyl7TQAlFtD5JOUTOan27hSJq+nztU3fAF/1W65PAlSutRb
	 Tpza3jSAlg3B6xpoPsQwkrrQn1h31PjbRBMn+zzDJcu7zqG/ElAgjZjBADdoJ4oHEkt+d
	 BmMEHI9rCGg6ZrKdb0enyl7M9v721VNRN0mVQVdcjzorbSdzUN8B47IhNnx7/uUk5SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186740;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gyAlktB7/fvxFToJv8yuwHqZuGY8e6CjhpJsJYAmqqk=;
	b=tSEypOXhhOiObQVKaVRPM2tBZKK/KuqoXX6YZSqENWVbi+nKDJbvvU4bRhwStICKoGwI
	 PA5RW5RRJGv+4SBysRhx+C//7wdg5fZSagUjyjGAIDatPQEZsmHxpzZ0KDno/Awlbnntp
	 B8bBZe7m72INbeBICGMnIkIdi/F8q4hh9fDyEP54aFjZd0dicTJ0o2uRWzSVFL2D2f3Gw
	 8kkbqPsuko1wYW3vNfeJUByEK5k8alQrFnzkdplqqJqrZicoVUYj8QPJyZnkFdgP3JMIF
	 h1w1dhLGAAqPOBVo0SPoZidCgCZOl9AQBWWXlYBSsbWVfhYDLlIJ6bsJgyiM6WaybEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mRBWabp6;
	arc=none smtp.remote-ip=209.85.215.178
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0B660A2606
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 14:58:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC0B660A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mRBWabp6
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc147d86bebso559872a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 06:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186739; x=1795791539; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gyAlktB7/fvxFToJv8yuwHqZuGY8e6CjhpJsJYAmqqk=;
        b=mRBWabp6oMqL1dds0wmPm0MhcAQATeIZm8hf9Rb8W10qwDNwC4BTkNn24qnQckAhiW
         QfEiDf2Xri7GViDajDiBXY+8Y2K43m9dKB6kaUELm0kahb7BH5lU+K9/JCFpWP0Cb7tO
         6JWS6t4/6mCOgniGbjuTKrVht3a1GwYcJ1f5dvODJx492Q8Nnv8Ra/gjg5t35O6UizlE
         pHr28Sa6JkDmHfE8Oknv6vrwKr20ZK4HRS2BpJD52xLi/satqZZnPUPRtWav/JHb93+V
         bOd7itUBXNPtRqaWi0kkxc0oAB4IeqXhTE8AL/w72/duyx0dT4mVe3HoXwdw1ZPltmmU
         UaVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186739; x=1795791539;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gyAlktB7/fvxFToJv8yuwHqZuGY8e6CjhpJsJYAmqqk=;
        b=aT9UfG3TzTCt5nMPukh2j2wx0JrSfaJSBvTqN6I1FxYJ193EedAcUs8lvBsqsWI636
         CVWmmkle+vsh+kvysNdmaNSDMy9YGlXxR8lkOGpWlk6oh5M3nPcmPI9iqZ4HsrAdQF8y
         miZe8ZirdpEUjsRBUeyv4GwRtyS4CL6M4/KHA83xj1JI5wRydQO8eWOvNQMTgAxDHFLV
         yN4CgUqXsfEhDSPq/8wFv4WQeOxHKULPVRbVLgkTGq7Z751Y5IZ5vqVClztlnZbMAz6m
         eW5ZdUJYQU8QEjvLFRCvu4jIR22krWO8zdYxRNeyfz0WPcc1ZDj/Jg2Trjg9M4bk50cs
         wZ+g==
X-Forwarded-Encrypted: i=1; AL+hErEWk5foQeceEi5HKHUKAPzQpyx1DTtmbbJtYelMNBLrBV6XUvqaergTztqJvJTfFPxHRjPG4y/Te1dr@vger.kernel.org
X-Gm-Message-State: APuU4Z+me5w2r/Ryx+zt07MqKTH+iMvW7b8SmiUoWQ/GFO77j1aBlOtw
	Ru8fR+l7m2vERIG09W9ZPs+YU9HZVzpqMVr0Tmh1PpUmBp1OQv4Ads4cLoR5N2nzjy4=
X-Gm-Gg: AZFdTZcdF9b/a9pdJjNybzQCiOZCiINNV/ddSWveyfqLfMsLSBiYsPcrJfDSuMj+8JC
	iGUEnV6XH7f43cydyDa0vdq8lvo6mA7jqyBaJtegbTSHUFgfIwloyBxDrvCEt3aUxq2hWnqmqY2
	/S/H4zeZpM1nZMfkti90dGxIGwbUOYN8aC33spTyNNSYM0H3sEEH6FOoTDqVgZ6CrEUOkUXdRMy
	VGCGYhnhT21+eqxR0ZrItrusrhmfQ47j+RSLRYTG9Oh+ZHCyve8YZjr740a9nT3ZPOxqHWd64dD
	U5aNTUSErWQmnpU6t07sSTlagXjkAoSPM4ALE2MQWLNsXcSN2FDeZTh84N+IdgqSXylZc4b8V1f
	jhrRAyXQzL7PUi35/9/n9QW4vaGPMJSaAZC2zi/z9FHLwRx28mW6NMABelH6FX3hTOQRqBkB3ZX
	UvpTzeu9I+hellcim9+UDUYbk6O9kuAqQ/gXod155+8BaBfH7obOvPlZ9doeM/DFCxUoOSjlgsR
	DAAHq/QEH/6wL/0h1YtwvytGNGP3SwAWeLQs/QTuXq6T//D9QIOAE+eYlNLLw41+lh+W5YnTDjs
	JbPG9eP+YutGMcoJ8QdehwdxV8hHxKbs+oEPId0ZuSy6raLFsnPcEo5ZNOUn5VxweIQWA6GR76S
	RTkZhm8/56JHqXH+V6e9sb+AUfXOjj2HX4j7L
X-Received: by 2002:a17:90b:388b:b0:3b3:b8dc:5e0b with SMTP id 98e67ed59e1d1-3b40a5a4cffmr3841142a91.14.1795186738957;
        Fri, 20 Nov 2026 06:58:58 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cfe976csm1336540a12.11.2026.11.20.06.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:58:58 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com
Cc: martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: libiscsi_tcp: check that a read got the data the target claimed
Date: Fri, 20 Nov 2026 23:58:53 +0900
Message-ID: <20261120145853.3127796-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007044204.650687-1-yhlee@isslab.korea.ac.kr>
References: <20261007044204.650687-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, Oct 07, 2026 at 01:42:04PM +0900, Yehyeong Lee wrote:
> A target can finish a read without sending the data.  iscsi_tcp_data_in()
> bounds each Data-In PDU against the command buffer but never adds them up,
> so a completion that declares no underflow is believed and the command
> ends with DID_OK.  The pages keep whatever they held.

This is superseded by v7:
  https://lore.kernel.org/all/20261008063248.767676-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
