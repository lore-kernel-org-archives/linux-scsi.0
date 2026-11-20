Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186815;
	b=Eof1Y9GDs61ynYxAJ9JV8W/stJ+oc1pdLkVVKuVYz2AtuG5MwhUXOa06j/ZKdZt0L+4h
	 z33dNQKEnTt1WbqOoYqnYN31IbIOZFnnXQ2IYfAQ5pkSOOlcjgojXobGkuQTUcyr0Tuf/
	 wsnv355YNQSfcLqPD0XET/laKmKRbGsaWodisZOVGXcVcVY7UYsHXF/tIUCPjCaQjEEFH
	 UUni5xYasHLU1AUkUDD2CBZW0mU/W+TyIXuEfvavM/FFvB9rHROhQJL++FOQx4O4n5QB0
	 DtLzobGV40RVq234qccXxXKb/ASJfCcHdo5ohYGN22xAshQoRw/JEaV3sH31UULtZvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186815;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=XHBcZQlUPQsO0ifHNy4xpiTb5H7JDbYhI3unlnSE//U=;
	b=Ekn/IT6pFFnNG4XGSCtZMHB2TfGJtSzq4IddbINTU9JRUE+yg4+cDvADXHi+6jXCo67J
	 7VMcv1qb5RQg/Rt+2GJsML0l2P4CS8X+6UPqmIgjsOG7mgLxMrrtjWpv75xcjTNE7K+Us
	 0mK45HwfGLzlzTFU4WIul8b3AL/LULPDrED4jTtlJqm/FBrlxTWpLpLOCdAbytDGuqbnB
	 6/olCF0o5Lw1jGIt9luzRQENDlvv9ncSlEofB+ueUgMJP+b8dlEzypCrH3ePOv92qLqKW
	 aoyu0scrN2h5b5UyhqxkZZXhIhYgX3MnPPfWSV/NJ/A+prTpHezSW7/oNLX2Fu+G5og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=dtioWFTB;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED83B60A381D
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 15:00:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED83B60A381D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=dtioWFTB
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ae6b4c669fso1916815a91.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 07:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186814; x=1795791614; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XHBcZQlUPQsO0ifHNy4xpiTb5H7JDbYhI3unlnSE//U=;
        b=dtioWFTBD1YkaoukvSZcYfvqEDVfya5uYuCMI2+ZCieitU7Z/N1+ODZcyscKUzydpd
         8VKZH+b4hC9sikgVEJQUg4PET/IvD2ongCBHovN1rQo5wG9+dvAE+bprivp3bcMXs9Ty
         8MW7/rgBJapUmTmb1vsjG+EviwSFdW7XP7ZqhOoV/0vDF4ZiRjlj6UqBKxAMAzLZMcj2
         N3vLa3/P+9zsPIsUjW/sM9xm+zu6Xqf3GBcUv3KS73PS7bEwGRyzHaPTFYklhkc6KdiL
         Cmx4j2YIcPlRxyO3rAYofOP2ogVEi1556SCGH4nFhE9V3n6feBvnCSH4X/jpeEnxC68g
         bleQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186814; x=1795791614;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XHBcZQlUPQsO0ifHNy4xpiTb5H7JDbYhI3unlnSE//U=;
        b=dSVzBdc8P2+c/wIUOufizEAVdTiC92no/GcRHHm69sXqWGjskB4cxrSfktN6S0z+a3
         /N3IIh/BvgLsT7xHZqfDu/34acIf4tZsvsO5DC6ZYbZ/aFxanCd+tpQESBaWCbJQA5PB
         LW1SiL5naExTofR1XK+7PDmQmAOr5k3rR83JrwVd2xAzr/kg71nWp6vk+5tbISr20Ad3
         sgWTDB+SsW88LD35vNz9wDuGMFpThsUSksfuE5aaWaLq0FVunFXKQtnmoB1fAvnZA1BB
         p5sPQsoeQyHC2knD29sy+oDGLsAXA4+c3Kjvloj0yLcR8bqFromv44sCscWYJ066sAPR
         oKJQ==
X-Forwarded-Encrypted: i=1; AL+hErH8fY2ibClfSLuTIDDIWBUk27rFIt3gtg8G9la+jxu8ZOOvsoQhKqMmmIHSMBE+Bm4ko3xvJnky02FP@vger.kernel.org
X-Gm-Message-State: APuU4Z+FJF7mVu6xbA7WtPKBcaWPb+wePTdR5WhanLxXBYXX13Jt8toG
	Rqp6Mm4nGp7+5EQSdxubESbW2CStJUsy8TfY7ikf4L4cFXVvZHzxwIKTFi42Z7tGoGBo0sRRCM4
	Y/Kg23Lw=
X-Gm-Gg: AZFdTZdFbxm8Ep8+nWDcyIkyl4R+I9c9rPMapohJJSSzbA9Ox9i0qP6rWP2FwPAxWik
	CCcGQvgJA8QwxPoNGbecCntcIx02IX45g4srguEbMsuri5Uekf0cIH3HELhFVrrKVWev9SVviXA
	K3ZZdfWAdnWFq6c+pADvxcQ1WLN+wupCvYSyRqAJmn0gP2Q093Pjr1/KjJcPsI8F5QgeIQiE3+2
	jOH8KzQmTy9BA8qvAUhFFUzC8PclmlwT2o6X5u8Ni+qXlAqbMCRpKLDtqkuyOpdJhUXa/p0tthU
	sy+mw2TMDJSw6r5DqykER2HT6iM214MSrNqvRGaUhW03dBpWKabTFzD9flF498wZkNsRhsH26vB
	DaMnzFDrMQ+hNfhMRZYvSafOPTGfQ0A9/Gs80YfWgX0qh3jCpo5qlQm6jeXIAexDanwk2PkmxBv
	5gi+XyOh+jgWR6vw3i27LRhOBIEVBtDn4hMRWK3pM4fpoymPb10Usns0Sm6UEMLRloDuRIonFoW
	1y08ZhxWvhZsQi8E/9+KVRdscaf8qaMq/kUx9VjJHHbcNIQIkLYQpjbzKag2SoB7AIHxtkwM5eN
	Y6n8leW5BBODNa3QC4HSDBM7YzmoyYqn4EnsWcH7X85+qOOuqh6IJyHTSXkJrzV6B0H2LtIBh2W
	88+RpJLoBzOiHqar7ROG65jG7M5ZDMYqtmS1NQQ==
X-Received: by 2002:a17:90b:4d87:b0:3b4:68e:1b77 with SMTP id 98e67ed59e1d1-3b40a5dda03mr3742019a91.20.1795186814085;
        Fri, 20 Nov 2026 07:00:14 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d02ba46sm1367360a12.21.2026.11.20.07.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:00:13 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mvumi: reject handshake sizes that overflow the list allocations
Date: Sat, 21 Nov 2026 00:00:04 +0900
Message-ID: <20261120150004.3128120-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014004226.3469868-1-yhlee@isslab.korea.ac.kr>
References: <20261014004226.3469868-1-yhlee@isslab.korea.ac.kr>
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

On Wed, Oct 14, 2026 at 09:42:25AM +0900, Yehyeong Lee wrote:
> mvumi_hs_process_page() takes max_io, the two command entry sizes and the
> list depth from the firmware handshake page.  The entry sizes are u8 fields
> used as shift counts, and 1 is an int, so a count of 29 or more makes the
> << 2 applied to the shift overflow an int; a count of 32 or more is
> undefined outright.  max_io is a u16, and the sizes derived from the shifts
> are multiplied by it in mvumi_init_data() to size three unsigned int

This is superseded by v9:
  https://lore.kernel.org/all/20261015045213.3975845-10-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
