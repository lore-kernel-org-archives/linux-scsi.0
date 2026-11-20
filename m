Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174959;
	b=1WmWke65jfHmEW8lzvbHE/5xbz6y9g5P6lThooz12QP9VgENY3PYkmsS2IkxBOPdRCQy
	 D/Kgs+VHvyX6q58heaHgqEBCJb3cNo9vw/w8cnsXg5jNqOedffeMfUEfgMZO2tMxu8KSQ
	 fKJBqV12PPWFhD4B8GVwMwjM1JOQ+oKKMjdqXKxK30jwusbNMEGunzCrtnQWJxXJYW0IK
	 50xYcoRDwSdNbCta36Njicf4JOoKv8+BF6MAEaOw6zRm1/TR3pIOhIOqSeEcFWNpTmG4z
	 ZHRt4XrYfh0ZGh44gXpenX2LIbrYoZLUm/O+IN+XjCySdk3CPRsLbxTNC9hplVa9h5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174959;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3zkI23j8MahfPJVW8qMcXMj9oI+W1BwYSEzbCZAbKEE=;
	b=ibo1rxqI5GgyXzU29vTbZIDdrCAMsgl2IrPcGqWAkU4O7rZxSshwpKOtl0f3pcCilQGw
	 EmVci5wRC11T0mH+juolxn6jGGLtaZLYJd1/oQ5qFbXkUKOPX+jvd3owrKRknsqMeJGvA
	 qvk+PHewiANxTNIDIQdwiKRSgYFaa9IhZt1WzXl9xWCh/EX7WwXQU1L0tRmQkOo7o8Cah
	 W38uQvDqfpfvtlKbnxn6mV1JotgNIOYHJGqPduNdYBggGtncVqpcpLYMB87GVSaX4ybxN
	 Mtx6G5UOT6OLiY9EKBWk+udGIV6Sd4K51Qb9syHo9/QoJXAllUAVb7scB5Jy9Wfo9uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=slT3Sf+o;
	arc=none smtp.remote-ip=209.85.214.170
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174B9606A320
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:42:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 174B9606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=slT3Sf+o
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2f02ee04378so6103055ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174958; x=1795779758; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3zkI23j8MahfPJVW8qMcXMj9oI+W1BwYSEzbCZAbKEE=;
        b=slT3Sf+o+/njjw83JzBBA5ft++fNJqgHgcPLr8Qwp7R+GLw93bG3ugU97Qn4QvRe9+
         pmi3KWx3ywLMfu25bz1x2SWKkk2Cv9X8qlr6SG8z0JjCRA8TCWzKxLdlAr4zn0uz8BTg
         07Ig+Yd97lZ0zZIkcDnMkYbyb2h9pL1yHysIXfI2DoHNjMAlq1nR3LuRx6j7M0fCaxn+
         6Qsp+vDYQnlR+UqBHlsU33434ww4HBuc2I+Qgo+EhNXgPU+JGndDBw2JEF/PEZJPuQOc
         m/3wUBg8iRX5NfJHB+t6fpRcVlfazUIvB1iSpzsI6uE6uJgXqK8Roz4lB4uzKKvvbaUj
         vklA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174958; x=1795779758;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3zkI23j8MahfPJVW8qMcXMj9oI+W1BwYSEzbCZAbKEE=;
        b=qJ+dL+hslwNFUlU0J1D3feqU3V/C7cWt2h4hzejRLpl+FdP9kRZu/XkRfljimHjKQ4
         gQznMG/kjUUztUU0PzOmMVYPKnToOLU+qoAqyzEqA7WLDmFfpd6LQiFZ7J2173sRd3ou
         gelkbzkp2okErs5RoYnR8wLugKVpt9tzDv1didpbnRoCWmxOhT/wK+JiHHbLvlMLzc4t
         iheTTObie7Ly1FbHrIvako/uMT06n8vlHhC5klgIbG4B09F9bOBfjbf1gpB2ZVjVvymr
         Hs0/1p/YOuTag/t0Ezr1DR8QimllRKJpipPKs7TAvuD/gW07CGhmGUYEB4sF3r1nRjG+
         zK0Q==
X-Forwarded-Encrypted: i=1; AL+hErEDSS4IkNufHEyIvuZFsSUWCbUEsVXSWF6Le55dTdDT5oFsZkxaMcp4U53hYpLgL1odpywKFhffyxnv@vger.kernel.org
X-Gm-Message-State: APuU4Z/T01y198I+zHYP34lFJHHCouLh/a92xRORFnpqIoMjO/SPjg89
	Ua1be4gn5lWFdvw0dWykrMNQkt5PwgcMMTUIhvs3CTkEQIHkYWjiXnWRiPX254gTUYA=
X-Gm-Gg: AZFdTZee8Nr+eVsfvKbYJ+cUs5tf8+w8cHDtZYQGCEh5+FjAx3YLmnfCXJfwrXY5rHd
	ck72R6uOYtgul/LIyzUEXuzGU3CaxCnKujhJ2fQZlAdSi5te625JD5cjSSkuQwQVk9oSAe84Frz
	wQgpUcr05eZwOWXG1UrlKC2u2e1Jo5xELhgvGKVp25P6pqPDStKQgpv1jBk8b+ZeinSNCup5NcD
	h99sRSVmYwnlzAzTmzbjJkXhn7NflTsCmk8v2Gf/lbLXiDcB4rHRncSaD83gJY8XW5LwTyGeYVV
	1sPAe4lD7MvTQSQ+xPoE3dIFgveqmOJ4UJbW/OdAnEUN/xW/5N/ok+0iZtjZn9JD6OgqivBa+C+
	jPlXvZI2krXKvB5wpvbB3c9sQ3n+WGn7eoaSadP9TxS9td66xAKx8dcvszSxWcKmES66tP+PCNa
	RBmrWZOocVK57upmxT/At9SRJK3jZgYled5T9w4E3Mz7CGfADKVm7IsoWbDexvxs4AArJBZzjJK
	Cx6eN7rlJbC02DORUIMGeMFc67AdRrSBR9vwFDQBrAWgqMYL+Bnkn40WjZAZHwFO8/rAKNnVr8n
	NMAJ3hcnqslLVxby+yMr+fBxNdSeP7KXgwALmQjXYcJ9Ld/g1XYMxd0tbdB5hEMhx27A7Jx/oua
	YRI7yLGcX5eYXqKslova3UpVFdzBhydMYBOOm
X-Received: by 2002:a17:90b:2884:b0:3b3:c930:35c7 with SMTP id 98e67ed59e1d1-3b41c92a1f2mr2728231a91.27.1795174958467;
        Fri, 20 Nov 2026 03:42:38 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40578d771sm7166263a91.1.2026.11.20.03.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:42:37 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com
Cc: martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] scsi: libiscsi_tcp: check that a read got the data the target claimed
Date: Fri, 20 Nov 2026 20:42:32 +0900
Message-ID: <20261120114232.3072170-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007070207.666738-1-yhlee@isslab.korea.ac.kr>
References: <20261007070207.666738-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v7:
  https://lore.kernel.org/all/20261008063248.767676-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
