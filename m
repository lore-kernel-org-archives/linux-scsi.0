Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174991;
	b=b6RuH/iJRGpTNOEsmXbvpF4VSFEcHMoIDeLAEt3mOgnxyImy6MTVoH+cGHV24KI+I7bf
	 TkqNn6v06nTCIb9bKYUEC7D7OuC4VLAkYB9KZwIEsDOzD3PdoLMmEgFLtiZ4/m8Fa+neL
	 rune6RhUIQxoQhMoQNURSOQxk6N8DIhTYX4wGl+e2nB9qLLyksdunl4ETPjDTEDxg61wv
	 mNVlrKjbGPanY+UgkVD/CwWbA+V+lFXufDsN4hPEMBGqr9Wdsx4F1v0Lq5+j7Rk4FFNFl
	 u2jMSKHeHyqSe3NGKimWLKBSCBfyEeeTXOyt12Y0aSmaxptxi6GvffBciUD9JmGZbwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174991;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=tjGZ/Gq7+UhVAkNckCXeXj9Z4u/UvTe6D1SHPI36wK0=;
	b=SU0kuGDefSJt78nFAPu5TWJnTcpIvK2JyrTB9uLsuUiNFWGo5LtKQ+fB9J1i12Q1oUaP
	 JOTxq/nOeFE3K7SnNgRb/Bbmdd03zIium9Xi2Qk/IerM/Oh8XH8U13ZAOOUCzg+K+KGf6
	 jqaGRfhqs29pZbak2ilABZkO2QOJYcLo+ivjNB+ETnqWHMXv1x9mX+Y/jsJ+k4EjWcg5u
	 s/Z60jWECwxZtusYFjTRyIvfxPHNv5ATDQgFxx2+GmJ09AFquFySo/zSpduke09M0zelM
	 KGKLCsMkqGTS3oxn19Ul/kirdqY9vHMLPjhgtWv+0l+9WnZgTlc871sh2XghDgtwpCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ZxUf+WvL;
	arc=none smtp.remote-ip=209.85.216.45
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171E7606A32A
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:43:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 171E7606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ZxUf+WvL
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3b0ae87069dso380811a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174990; x=1795779790; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tjGZ/Gq7+UhVAkNckCXeXj9Z4u/UvTe6D1SHPI36wK0=;
        b=ZxUf+WvLCf/dJltRY0rSyC725l+Niuz7njCp3qqzff0KKwxSKHA3Xh4lK0PG3fMPnb
         7+iZHju9fGufQJE2QlXpD7DsdGTcv+tp3OOQyDxYLF3tBC04VnKz9Zsar9RaaiAnbzDk
         fzNe6cfAr9JJtFXRYCDb03ECP4Se9nWPRDsQaT/4TSiylTdgycfKANbiwDstAkepKmbR
         kD1dF9m58LSVjuBz+gyxfo2BkC3lznj7PutgbrNNJ9fZ+79dwYEW/opbrTTJLsfQx1Da
         Va6yGKX2c2IilH+m1PYi3MaAbcSgyvIvBXKLLqqZRKguv3sQUV843xKXo5KSfxlsjDdv
         GH1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174990; x=1795779790;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tjGZ/Gq7+UhVAkNckCXeXj9Z4u/UvTe6D1SHPI36wK0=;
        b=y9pu5sXioC9KPhdcR+N2PWXx4+MZxgOBLMewLYmt/yWSxRRGFGmBJ4ymRsmx7uv+GT
         LQ3eA8WV8gV6n7MIpWvc9jYJz6xwwE5ixtvDIpwxt047HHc0sE35ywR3Yb6LRyFhliaB
         heZ3Sv8P3Uu7aB847zlnSY4DyLtGiOHyBBy6slafgzJAMNJFpuTypYPVf+1flDjnexVx
         CYbmcK757bfQrP+vtxqzRK8JCv05ax5yEifq5rSchBQPT+0oxtsUfJc5NguLCg8CFCBA
         LVVlNSff+g1jZEaYNvAQziiqmJYY/jxct7knTp7YXw6Om9Otp0pxoBr+AxBdz11lw9VH
         rY+g==
X-Forwarded-Encrypted: i=1; AL+hErFRYf0k1HA1nW9M6xygiKdc7t7zG4vZrfENuE6X+useUOj8lDyl8FKuaz8csoc3jQ+WQYUXAB+mP6s6@vger.kernel.org
X-Gm-Message-State: APuU4Z+qbu3Fi9dhZkGz4eF5cGcb7narRSiQc9SRGp3dtKMjcov9J1pX
	ZtyWm94PB8T55Abtb/PvnkJyaKftaRwQ3JNo1hLhX4dOEy7G8JQW1ZOM6IpO+KeYyrI=
X-Gm-Gg: AZFdTZeLCWXtFhEtFwPYLOchfblqihNYaKmJxEw+jPA9hUYBkHUvq/y+C4XZ3kzsncr
	HF9U6UtW5aGAhqvEY520A5Vz3phq5AjnIndMHkpa+h3YCyQkjLC2PnnrUh+XkY7kS1mBBM4tnro
	Af4mUO7WSxwd7hQy3WuE7e52+1OXyNYI7ja2UvV60RLHmLnYN+HeMjnwz1noSUKrJo7vkYld430
	hbeC9Y7MHWiqaa3xrZwJ4O6TSR5li2dsHg5CKWutMR8VbtB96WbqWJM7ReUGB0czBc/WafNKgso
	4ItJ+Br7HDqvDivrpiU7IZT3sdeZ6q9m12h81CGbpINYUpjD/0aMOVU/xvnmUu8jZkVFkzmJmda
	zKSUIPlvCkbgN5+iJEuQ4FjiXMsSZ9gpC8Naye61KpklPenXO+BJKhdXotXhDo+8smaGPBnzORx
	WwtThLOhQUyU3CpAF63AEAqgwLxAAENMiUQ+xa1tIMDSKDc1VQvQ5ZBGNZBT/U3utv8cqSBUYTT
	UKW1h85AWglcYvsar4CZVw0dMTwVVz02SFseEg/rctJ+lqyBItPPbGu23CzE8gbxdRYkErnRgJE
	GPaSctoYllQZI2bHMe8ca+QrcQjz0hEh5tlGxV8LwuoVjDgG6ZjA9dcgLd0tTYK3giVAczRnKhz
	D70m2tDgE7P8pwdpACvRm/YS6xlNy4rVMVoLA
X-Received: by 2002:a17:90b:3d92:b0:3ac:83c1:2c0 with SMTP id 98e67ed59e1d1-3b41c9b2de6mr2390953a91.64.1795174990371;
        Fri, 20 Nov 2026 03:43:10 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ecb486sm7041802a91.16.2026.11.20.03.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:43:09 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ching2048@areca.com.tw
Cc: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	thenzl@redhat.com
Subject: Re: [PATCH 0/3] scsi: arcmsr: bound adapter-supplied completion indices and message lengths
Date: Fri, 20 Nov 2026 20:43:05 +0900
Message-ID: <20261120114305.3072260-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791789900.git.yhlee@isslab.korea.ac.kr>
References: <cover.1791789900.git.yhlee@isslab.korea.ac.kr>
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

This is superseded by v4:
  https://lore.kernel.org/all/20261114033810.549787-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
