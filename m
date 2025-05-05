Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053351EB5F1;
	Mon,  5 May 2025 08:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746434191; cv=none; b=e21QQQplKXBHOHt457FAkO1dhLmAive4Xtax0pOQ3hQ75ss2/Caz8mWFzJJBh1lNJKRYwCC0BiVFZmMK+zDC8CSE0w1AEFORW+tPYfTMrhO204CXNMx+h/FzHMzkVFHubLU017uKeJmAGPxlQkCtx1P++o+8Md/wSqbu6eGQmL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746434191; c=relaxed/simple;
	bh=UxxXXb4eNPbTRv6J/LOUqTZQUX6k1mlofRFRhluoY6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NZnlwAPMwdeicQNnJz8/ZsT9/vGz5xEtH4cg07apP2gMSN19QX4aHSzFRuTRhkHVTmWBkXFYYAGAtqP2cpJFzm6/O2nJucu5OaNT0Iz70x4LsFayXiOAI68Ce/hSYqly4Aq0/anQhoqdtqMwbe9fjXG5FkJ/39NFcoyeVE0M4T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-39c31e4c3e5so2421394f8f.0;
        Mon, 05 May 2025 01:36:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746434188; x=1747038988;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UxxXXb4eNPbTRv6J/LOUqTZQUX6k1mlofRFRhluoY6g=;
        b=H2JO2W56ZM7AnVwM+HU9bnc40shxeJQXFRRjiDvHvAyUsUi/G162hd4RkXlajRv2Uj
         1E/a6bSvcFt5bf24VG+0ZAA76HqWocNp8UTFSz40P37xMRb5D9C3GAc3Tn27F5w9KDeg
         UrKcp5ch50R9NtOIHdxv10OtqyYULFLCTW7V8yUoftVjAx99F1n5O+V+ezfJwMWspahk
         cr6GBkjHX87zTn7AqN2B+QeScAIGxtF4LxHsdrRUChrARcCn0uofPhGVymQs0qRnPh5F
         Bu5P2KWOxrRhuEgz+MSL3276xHN8T+fdofmE/BomBcmkuCLCaLZVU4bnkpGKkRhCE1Uw
         LYTA==
X-Forwarded-Encrypted: i=1; AJvYcCUmbClQZ8IJs5NVeYR/x9FrpPAJgOP7Id9xYkX+UFsshvFrQ5pd1PZip0oRMP0JZNWLneZWqZhLXTC0@vger.kernel.org, AJvYcCUoa8gxIYitPFhOAVfNe8hVFv7YspIdxH8Dk1xpVqz7tJW1uttEruNP8iKxudbxg2ytT11qS8qOxNTRKg==@vger.kernel.org, AJvYcCWT8lrssH2qksskTT1imRoOYeTJ0B2ua3RfwCazkwM0PgiSU0/ZkiO00cExRAk3B+pQMCPxC0MKKvZcAw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywcm0ydFm+l7KegGXFZB5ZJylyu645RVjQSDgNsGayMM/Q1lLo7
	nKcPvYLP44sZqq1N2qiHZpMMqmkyYiiw7lrmgXAyxrKqxP8uTE3F
X-Gm-Gg: ASbGncsxUl/Dt/5ghQ6AIJD8lD7e2lvVMG7ltgCHl9Z9b1L2Nd+J+iCcIYnDbJDKZO4
	NAgaW5HAT8BTKm8gB7VHVNHneGHvWAjPhi3L46GufAcLQ7iNTsyrLtsS0Og493y+5DHXE2AP5i5
	x6dP8vLBaTAlNA3Y8DNExDbp7u/5dXFHVa1r/Hs3LPDm5BAyKi3lKlauTaXm/uwkF+MMQ7wh/aS
	Au4PL/FN8aUXell34opTDXT0ebrRxBZm+jViwkpPFXwVixU5FRv8lUjBbN6OUIzE1EBbBHTije2
	GzDg5yDAUhDYNt09xtAl25ev5v9L/Hxn01vkGYf8+oSyG5nzqalMg1xjlyNu5NUOl40=
X-Google-Smtp-Source: AGHT+IFeCkCyeO31reiOlk8najmUkqXCw0IDe0T3Mbw3++YmYYv9Z0MZX3uDJR4yIDS/BZhDldE4jA==
X-Received: by 2002:a05:6000:4011:b0:390:f394:6271 with SMTP id ffacd0b85a97d-3a09fdd45b8mr5103083f8f.43.1746434188069;
        Mon, 05 May 2025 01:36:28 -0700 (PDT)
Received: from fedora (p4ffae10f.dip0.t-ipconnect.de. [79.250.225.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099ae3b62sm9801729f8f.34.2025.05.05.01.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 01:36:27 -0700 (PDT)
Date: Mon, 5 May 2025 10:36:25 +0200
From: Johannes Thumshirn <jth@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
	linux-mm@kvack.org
Subject: Re: remove block layer bounce buffering
Message-ID: <aBh4iT4okfgVTQw5@fedora>
References: <20250502064930.2981820-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502064930.2981820-1-hch@lst.de>

With the comments on usb-storage addressed.

For whole series:
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
