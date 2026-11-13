Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794613294;
	b=YEl96ExzJ4sdumT6x8uNjAbPmpkxC3a20/9zv/Mi0ISxsdePND368zbyafNhKxTpkPzQ
	 nYlQzchl85y9rI+hGHrE5ii51kO60MSRPegi+BoxBS2mnk6WpJEYH+tn/f8Ie28MbAnzu
	 X2RVT+PsDsRZe6wAD2T/TS0bPnxTIaMc8i1lI8cSwQuiBKXdoexqxT7EiOyWTUe505nJ2
	 9IYTllCuKn64JIWbTZpA08SZJTolMtv6xXPkpRbF8jzi4FK36BkwUsraaEOpkHvCGUeab
	 WF2SunN/gSkS2K0/Dy8KAkFR/TJUYDwXCxIr/R6tZAFj88330mKQeO9NYmdZxz3W7Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794613294;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=uhP7NsNuTURvYeD6nh/uw0NSt2AXYerXW40hmLyAFU0=;
	b=Oepo7Ko2h3WsZ6fBsYlwF6wqQKg1pxSiJaNNQe9uJ/1JtNpI01SrkCR7GfLqev+5pPx0
	 jy2J5EeSWm3EvhIWr1VL0MjJWKe4dIN2AEbkN2+MEF/ZeaYfpq9lhRmHSpc+MbO65Lh25
	 VLd4c0ayBloixVq4rPVYvRnnuoODCCMjHh6TdEXlHhccUvteiCVOPC+nQXntTS1D88VsT
	 ryvyi31WQ00J97f+4i1jqSTskxOjGxSvnfIEH66ESbWz7OtXBjMBAp+yej4AMXkLWjtnB
	 Dd9OThVdw00Gh7Ln8E3uMDdxOXs1AtrLkQifT9nDW2EfLawXBng8qRyRkZ8/2np6vMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qu2sj+hd;
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C472B606A88C
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 23:41:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C472B606A88C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qu2sj+hd
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8a0880a46e7so722260b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 15:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794613293; x=1795218093; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uhP7NsNuTURvYeD6nh/uw0NSt2AXYerXW40hmLyAFU0=;
        b=qu2sj+hdlYW06N5f/d4sV4hcAzCYdWk3j3lk+fV34nlII0vXpdosbk22gILAhYnUUT
         TTFB/iCYalGOLI+1sl84d0y8Y2UlmXFzRuH9sMNPgO/dbxqo8lGU36RgnYJDXiXa+/3+
         MkwTT2gcPv7uYZhFLvjuXvXI89yDPZZIRGQDbqCnwGbYIOhOsA756qkID4CRxN1xVkdG
         4z0KaaLRijsXSew3yEuTxTDYM5CPfxFb+Cf6h319eQYmk82JJqlpy5kNm2W5+DpAwFs/
         xQlsTkJi6Gll4HiNP8r4pMrbuW01+QtL7a7Z6zG5wxt2HzxJjrOBQV+xFBot905YHGR8
         KvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794613293; x=1795218093;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uhP7NsNuTURvYeD6nh/uw0NSt2AXYerXW40hmLyAFU0=;
        b=x4pwM1SWPs5WRCIvxeHtjE3qxhPzPxwODgioW2JW9kiGaRJMS6P0oTk2/3leFdXruh
         50hoPsrlnymYTAHe9JNTMzUfADTEvXyadb6hriZokwU5y29Qw3tSEb4hCXcvPm15CxyF
         oF8VuPuhpZojQM1qtAPAQagzhGwgVUtJmVJ1eXZqw0No9fJHNzIBvshgEW7hxZrOBELQ
         zGX9JgYTH7zJuMpgxJTo3TZd6R+l4x2ldbY0naUbz3HDQcnP1U2cl/nwn5C2tTPwPf3E
         RAMqn/DN4XcKUcAc1DTKcUI8DtJUgrAaU71rvyKRO6cEykX1NE/0QoaZS4huqPZtg+RI
         6KBw==
X-Gm-Message-State: APuU4Z/8Rs/5XDe0C241BgBG4COwIxRPIQwHa3r83MU9POrRiEGlwxif
	w/6PvwBpGfZ7dRalC7GfXqgWWS6eY4OJPKCqe0ixQ2921bvdzAIBmX7su4Bw6CYhrNw=
X-Gm-Gg: AYBFou1l+IbDAmw8c5tNkKfRhwLvg1iOvl+wviRc7erdH3JBNGVVLp7tLhqbs8TPoI4
	eUDJ7UmTg1zHr8mWKAAKb6dZJajJhLcR06PmPEqZUM1aiQx5qGIT+efRHl4k036wTlS3dDimTBq
	Rn45Eq8w0ejKp6hGozUTkbmukHsri9oyD2/pAYIg3r0ReMslQw1Szfjnb8z7CQviNgXk1xB35dJ
	LTSh7JzE+TEtvLhMPgrKwmAUsZDrkfmByku/M/9J+jF7L8NhiWY5imF2Upc1HqtlA0RCXiUcJNo
	Px/Zl71aDa+jlK105jRuXFN6OEkG+JoADT4yGoCqJ6mKgGXfZwiTb02HxnceYNHepQfZNYq7NbD
	C9dC9j4X82wkjgBodl/gTRffoumqG+SALQ023TtFVNt5PVctNf7KCY+aJD81Pe1N3/In6tqHyez
	gnZUOj8fGKuwKv7eEX9Hnkk+OkPRYEY1YCAYltCWTlWiUZyJJ+wOTO0fRJVRl2vfDimPpMuDiFn
	8oSGkNmIu/e1CWFKJE3f92XgK20VUCf0VjfTGooGcLaLx3NLLN43+CoSKvXPMPz/z2YpbgI/wQK
	VMxAZNZHs6hoV8NYCnSCvekx1BheEDQDpps7VTmLIyBHYHyBise5S45MqQwC4Q+mwqDI94RErjW
	xHzGfrEr7lQjwJtLxGHttAHY80M9f4igU4LhxHEo=
X-Received: by 2002:a05:6a00:812:b0:8b9:66d7:1016 with SMTP id d2e1a72fcca58-8bd62024937mr4783752b3a.8.1794613293130;
        Fri, 13 Nov 2026 15:41:33 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:f861:b117:6318:c068])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed205364bsm1768831b3a.33.2026.11.13.15.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 15:41:32 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com,
	martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libiscsi: do not complete a task sent with a reserved ITT
Date: Sat, 14 Nov 2026 08:41:21 +0900
Message-ID: <20261113234121.397606-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113232322.395246-1-yhlee@isslab.korea.ac.kr>
References: <20261113232322.395246-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v2.  It depends on an earlier patch that has not
been merged yet, so it did not apply on its own; v2 sends both as one
series, with no code change:

https://lore.kernel.org/all/20261113233938.397415-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
