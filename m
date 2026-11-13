Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794569313;
	b=NOgBBd0nD5/ptOU/CdAO8/cgHHzdcAYkrG9VW24Tjjrczr6nktq9WEW6lRfwtFj2RRuI
	 uY/7UfyvkVGNSkch4wy95GoQsYvxXwy7+hWK2QQIrzg6Yq2LNhXr6jxm3juSPBJLOzJwP
	 hSMKmfSjCYY4ure06kh8OtUGpVXbwqS9hpe3ubm08luhO91S0N7wv+ptnLAQYdDhhVZuA
	 K6qsVcADKRYH9V0LnevqNv6rtO2cOnFY2hlQvc3DO4/VeGJIbn+vjGJmyo7fRMI0beKkm
	 eUeyNwZrpozlc2MilAEHMNojcZIxyHMoEZENWlApjaKy3m6aUPrF4U4lc31dQkgh3fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794569313;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=Sb+fCAcXvYMXke6iLBRIj8JRjkfV6/2OJrQ8O5LVpDE=;
	b=boyijMy2k5L5ebd/9zNZFqyhH4RBrsiK1XrLXwPJeYFUcr2k3z1jkx8rhvMzqnoeH2pW
	 N5KwndA75wktGXyKOeAMHBx/J18RMV5zctPxJEGUCWk0z6UPKgrVY6+czm4moBh/9axUc
	 JQhmdHyg6KGWpcsA7bmIsNKX9EgjZEpuYJYFvoiux6wLsxURdQYMm3BrePcn+92BxswCC
	 4mKAOx7iAsMQZTYEuiz1e4L80ezICUWNCg9OxP1ACa4bi6k/uuSEcdaXjMjJ9PjQderoh
	 Mr1v4rNc25z7PZIsWuHO+1BkHYgzjJQbuAmDyKy6YBRz5ixjiioWfC1Iu19ZZ8Pb6vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="ISMcD/SJ";
	arc=none smtp.remote-ip=74.125.82.71
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F62D606A327
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 11:28:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F62D606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ISMcD/SJ
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1383723dfddso954737c88.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 03:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794569312; x=1795174112; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sb+fCAcXvYMXke6iLBRIj8JRjkfV6/2OJrQ8O5LVpDE=;
        b=ISMcD/SJdXZBW/k6cWD2EF6D0ymJKCsImzpO6GZAUuGqBuxtv62pSOCGuyUfApOTkr
         4YggTxbk5WvtI3XYooVrNFlEtLxI8s4VaMwMX90k8FfDZLUoPxyQk9i0TVr9ZOEXMGTc
         6l6nMcl8kP4qSkn/fFkOHGH0cTL9giZkIkFWr6zP6XxvbKjR20Ab+JguplocQsUOOSUi
         WuqPlbP5HqeNAzRdQZA7WLWOhhr1RkCGMZY0isEarUKlFpHrjVYNKTxUnFCcCLPHoK7u
         i1y8pcTJ0t0Vol006t6O6ZEdFhtH55Mdtf2StkxeqcWO8I6+W30j/wehIs9vX4/F7gbI
         M89A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794569312; x=1795174112;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sb+fCAcXvYMXke6iLBRIj8JRjkfV6/2OJrQ8O5LVpDE=;
        b=HAAywOCrT4YfahYPN969AdgVyNwYyfd/EjmnrraksTm4+eNqLblRHRlJ8lrzBVDv4x
         BpSvRh5qurDqdafIONGYfR8pMQn4dAQrVfdxT3aaTLkg0S/f4OAxeKfeAy8yz0FZrxCK
         P7yLX/1KMczAqauBejVljlUos/GrXhZtSiuN96LR1Hnn+muqd/r7Qiq65geRGjhjswX/
         TmclVrKUVRpm4uyYjoT1dHUdwkmYsFyyVWmVa7jIwJMyf4r7TM7uPn/OfRvMk+lLhAbW
         sbvsN3uQf5IuTLttcqHICLeQveJMUSdvj1eqlE1VM5LH3RLAcmhMtD2RCt0dRBLHOEJS
         0vGg==
X-Forwarded-Encrypted: i=1; AL+hErH7ubOJnBH9aa6gvjiL91IXTW7ZrH6497vlnVCdLMvgu2oAmNv+rysNQ9HPrHCbFqe9W6IYDw82tuIx@vger.kernel.org
X-Gm-Message-State: APuU4Z8rZPnl0TgB7/hyIb8pwEn/e/CucJ1mBKWgTSZHPdA7XUw0njjP
	1+QcKuLq1augQHnrkL/V41q0D4SlhbtHjc6V70CjOu3yY0mlVSwz3Mm32L/Pez1onQv9dkiWzTu
	lsAOsnORhBEGxRy9p/jKVQw==
X-Received: from dldz8-n2.prod.google.com ([2002:a05:701b:4188:20b0:1a7:c918:186f])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:21c3:b0:16a:f5cd:365 with SMTP id a92af1059eb24-1b503055090mr2164922c88.5.1794569311740;
 Fri, 13 Nov 2026 03:28:31 -0800 (PST)
Date: Fri, 13 Nov 2026 19:28:29 +0800
In-Reply-To: <20261104112744.1630864-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261104112744.1630864-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261113112829.3683667-1-stanleyjhu@google.com>
Subject: Re: [PATCH v2] block: Keep RPM_ACTIVE in blk_pre_runtime_resume()
 when already active
From: Stanley Jhu <stanleyjhu@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Brian Norris <briannorris@chromium.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Praveen Talari <praveen.talari@oss.qualcomm.com>, 
	Alan Stern <stern@rowland.harvard.edu>, Stanley Jhu <stanleyjhu@google.com>, 
	linux-block@vger.kernel.org, linux-pm@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 4, 2026 at 07:27:44PM +0800, Stanley Jhu wrote:
> Transition q->rpm_status to RPM_RESUMING in blk_pre_runtime_resume()
> only when it is RPM_SUSPENDED, and call blk_clear_pm_only() in
> blk_post_runtime_resume() only when old_status is RPM_RESUMING,
> pairing each clear with a completed runtime suspend.

Gentle ping on this fix for 7.4. It carries Bart's Reviewed-by and
Rafael's Acked-by, and the blktests-ci report on this thread was
retracted as a false positive. Please let me know if any changes are
needed.
