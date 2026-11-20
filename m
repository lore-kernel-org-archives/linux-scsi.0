Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174929;
	b=JOOEm/LlAKqXzWDvhsNQU240ph+/Do5R/qCq5qcfrZjsVt9sIslGfl0bsJ+uW46P0E7o
	 6/4h6YdP8j5uo9ji6wyq4/eSOSPetxgpFm2px1RYEDd3tEvTXajXgwCogue7R8OZNz5Jp
	 8GLHv0jiMs/fhamQAPAVV7mT2DgmzErp2zKXmOgZOxwudM7x0V2eoZg75dWmPVdXJjB2+
	 vgj8JQUHYQDoVsH+Ld4dxiwiEEJs+uA+7X/Xihx46LrPZvvSHSHW4yaVqD33DBJ90IhEJ
	 HSM4dH1h0s1zGpF+L3GZ87pkCphIrSqjHzhuL62+6IfLT6jrBss+SB5Rf0xBMXQSMrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174929;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=tM9naJv7UO6Voq+aBXlPWHG73U+ad6C+ZL6d3U3QEdw=;
	b=rLIZLSN+5T800JT04DBauX4ZRMpasANsu83pynZgZoJKi+pr9tVMkQRs1fmMyKuLgjDj
	 WX2UKORlVCqVg+ADybfr90FoYntYtqDrhgRTNw1DOJ5EgSwNNkQ3yjwesNVwGNisQO+8a
	 /D3x2yek26+JevVBMYbZNe2DRAoW7U9UrShc6LmX9nMlXpXMJ7QPIgFHZRdScZMWaTpVk
	 s9paQwv0VnnrMyj4W25gwq+wn32VTHbIWsqiIdZ5pFhHfkXbggeqfbm/YW/WMaexgAtdy
	 wquPqDiHDmLWdFXJWsJEwGYfyc2ISY/tMrGjR35VHftfYMvUZCZfBy78CX2PT2AVVvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WFYq8toA;
	arc=none smtp.remote-ip=209.85.216.54
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3934C606A325
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:42:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3934C606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WFYq8toA
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3b0ae87069dso380518a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174928; x=1795779728; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tM9naJv7UO6Voq+aBXlPWHG73U+ad6C+ZL6d3U3QEdw=;
        b=WFYq8toAzjU9exok8ixcfSZNb3P0glxTUSaEy8hOf+NhxldDGjaaUQwOSER1rPEBd8
         QVxRWO9De4zA8neTAaFV8QZiT6CAnxQnVr6liQRdNok4TCWdeBlKaEkLG3ptWSAugg4u
         J6AuIB/qiVgrTGjpZEW8i3D7di3Js9zoDxfdz2nwrbVhfh4PNrHGnQkB7Eeamo3vhoa7
         80LyErUdXC4vRCHTF/UoGbkFOo8+XCm2uq1wVbErarOv34E2c78I13V3iVYCGaqzN+m+
         37GLjgXK2Ak9gI89G6EZrdJ1guooUm2uK9BnOyaVlV5xYA1EvIRAu6ZoJsdwpCgoEvyt
         UTcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174928; x=1795779728;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tM9naJv7UO6Voq+aBXlPWHG73U+ad6C+ZL6d3U3QEdw=;
        b=gY5WNyulvuRhDljJyDyGfYPLIu9+eoEiPtIWCqjMxt6nkyoZh8kAn/Bx3vfGVq8tVD
         Xk4FZtS8ZnR5r6Lb9c95UKGg106jFDXENqTAYxiVzIEyXffBU3s7N6n2nrnpiYAww7TS
         ZCtXSKwBPIGSYFsDs3DiK2+atMks9KZV3J8EKkLa9GV5TaxyXcoBg5wNk859d609TAo7
         uydGcJmlzHf+2Ei6mtHfvRAlC5DlJ3cRO5r4xLd4neUqbeZXufkJyXQH93sxTas5v9Vq
         aKzdRgh+Y/0HBE4YC2LDefloAgO3i386WTqYh5/GZbC4uw4x8lfQ5cgFKQo3L9l+k4B6
         I3aw==
X-Forwarded-Encrypted: i=1; AL+hErHmiexboqPAQJbcsUSBjmjTUgfk+aTk0vzMB9n0raSB66lmMfbRtvzx3ZbDZyuubFbaNZZl5l9huKz1@vger.kernel.org
X-Gm-Message-State: APuU4Z9MYzNkYsbWqnwTDG3mhZIK3vAYAs7L6DX78d54KTdAlgTNChA7
	6ACR591ZObJl4vKex+lW9dXgs2+kKaWv+Qrygrc2YVNlQf5edRfZ0vyjqUSpz5bDndw=
X-Gm-Gg: AZFdTZfcBfY+HPFkEoZnmmwmXF/ov+x6hvFse+7iEVebkEdvN4IaAeJTwJJCefhmOmL
	g5itCOsHGvwwSZpY+iV/fe1vpwVcQ4zb1cDOuIsKXnF2SUufX2xAHu/nGy8Gp4rr3q7bJCduQmr
	djXnLyEZ+tRQPSrcP1RAOrwuIjW2Ht1vk7v/9aOsqOgyokK/ANnlowaPEKF9W61J9WuKD8b91Bv
	/FiTRCyO+GG5t2GR9RPG5m8HmBQ5bbkK0cGWe172ugjO3/Nessirit9ZakSfreP6r6Pp4a6nFpv
	jhPOeutgQCx4HKYCo0EUU0RKZYvEmtJeRMxD9HfIwRZJ8TFs6CGKJdN/xZr71uTyESWX9dino66
	73Hvr2g+bWN87O+5mkoUjWxhKKHMUMzi/u7iZLsm74P39FLHa7/GoBkDHcvxx/2wJw6jJe6xBBf
	Zx2W2sZwrTIHot21vwEI3p4X0Z8CoScaOlRQ+qIL/7bBhMcIdztOcVp26LRHO3Uzl1kCVImUtmf
	5o6Osx47DAwVzsIhseWyKbI7Y6Q6FVI/G3/cjIKYppVzrqLgybuGdk9n2FXeAgNcEDIffww2+/z
	TrrOqDIzbKdHvZ93wkFYb/Mo7vrSh8oJyYjEdREL5JG+5Py8XDn2MnLhQaoPOQQM7nXIxbULmnJ
	PDsTvTQJaUv0hnOo/7/kBVYnRUxRx+XDv+cit
X-Received: by 2002:a17:90b:17cd:b0:3ad:25f6:1dd0 with SMTP id 98e67ed59e1d1-3b41c8fe29cmr2476643a91.11.1795174928635;
        Fri, 20 Nov 2026 03:42:08 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b42ab9c2dasm849879a91.1.2026.11.20.03.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:42:08 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: martin.petersen@oracle.com
Cc: michael.christie@oracle.com,
	himanshu.madhani@oracle.com,
	ddiss@suse.de,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Fix NULL se_tpg dereference in target_complete()
Date: Fri, 20 Nov 2026 20:42:03 +0900
Message-ID: <20261120114203.3072082-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260725084939.694403-1-yhlee@isslab.korea.ac.kr>
References: <20260725084939.694403-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v2:
  https://lore.kernel.org/all/20260725165818.769963-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
