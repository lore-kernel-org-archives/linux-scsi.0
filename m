Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24AA199A2;
	Mon, 15 Jul 2024 09:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721036047; cv=none; b=dRUe1rTwOe7PUxXAx8gFtKdCn6D6soKNBTOMixt4YCBhu5QPoEqkpRpU1Mc4VTobU1pswYHzIsxQmFQwCrTsuFcG6472ebaQenvJDp0eQVC4rM9No74EY/h2Bt7GAPS6udwRCUJlDY1QyUUaLOJkMGLlfW1ZUKCaj5c2spjly3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721036047; c=relaxed/simple;
	bh=jsJtdePkienB11b2Gh7dlE22owXRs5pqbIPeZpvqS8Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kY6AMGQcKKH3s+bvef6U0Lwcsy6jQzHg3GuvpRc9ZMyOV6Ot5D95uGHBeZ6tbOT2gDqgvMbStCLrKriOzVcqzfpfHKwhsfu0UovZjCysFe6vzPRVHlL7e9QZF2TKdK7pE2QD139GMfBX5r4bLQm3XpwthFzdE5QxKbvdJpgh6IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OCFQo+q1; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OCFQo+q1"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-58b447c511eso5044963a12.2;
        Mon, 15 Jul 2024 02:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721036044; x=1721640844; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jsJtdePkienB11b2Gh7dlE22owXRs5pqbIPeZpvqS8Y=;
        b=OCFQo+q1EZKkM+C42y1BH4ZKGzRrXTeNNNdYGtXOhCmNscbUIyWKgTWlU9HENyIK1h
         5kSv1YchyJMS+om2cuuNOhIU8yFIoyjyjbS76BD90yk324z+RB8QV7cis0Nv5Rme6BqS
         BmmutjxetM1/WOH3UZlP9d+zmLSRnxgNQULen8GoKog8ORiXEAWHQRhu1OPcSM9HpXlu
         tpyrb7uehukQb5xMasV0M2Rg0eKbjvW+RDWxPhiJpDKxXz3qe+idVUeD7NuD6ONRl1/D
         T1AnmhXwloP436U6NnbUt0sRUJVUUOLjG3I23eH9RhTW1vKuAWnTuQjMSB4O3fIYGYzn
         KEuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721036044; x=1721640844;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jsJtdePkienB11b2Gh7dlE22owXRs5pqbIPeZpvqS8Y=;
        b=WIL4yVpqE6OxnN+JQmEhBMeq8eIfmSz7TvAu8H2v9T6OhEqH05RceCdLgxSsJL6NY7
         h013zctZMZkdNUzmY4DanZUIarv775o4IfjR//aMXK+JlA86zqzEBZbSk+/6kSn6br1W
         mE6r9yx4s62zfopAUYuYJsBdjlnjxZ6FESpcU/KnmEtNd29Gn3Cdbmm86d3iLLV9YSvm
         MDmhkP1JEYlTkerTrxqPXXh2U1bqShlH0CXGqDk2RJCJrSgYbi58QvBtmjdDGh9XsLM7
         bpQ13IIM7dS9eKXsCcA5sH0/FdKOk9sLhZkYliwCJ7N7txlW7Sc53bq5D2u+Ec8deClg
         yDGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWF4WUv3JQ9cHV9jmJ60EKRzShcqx9sJrzmCZdNzfJ0pWltgh0gWDzHrWIp+H7horbR+no80ywdGujaDSRvD1bk2lMvFyC2yixX7dF+M20h68FdwUVfsq4efcBqEEWGMJWf0w==
X-Gm-Message-State: AOJu0YzoTTs+DCpHEmjMwAxiMgziI6XKTsQYbX3wuxNwXaZ7OBf5fblr
	8ko8dA+GEa8TO8ezxBpzs13Uyw9oKP5whk3fsCx1/j3mkqL7TVRg
X-Google-Smtp-Source: AGHT+IF1iBD5PBdiW1MXVxPLPw1ldsebD8ec0RQWnh38kfGvPUgFftx9YwQtPep3wbySXU4twET9ag==
X-Received: by 2002:a05:6402:1d56:b0:595:71c7:39dd with SMTP id 4fb4d7f45d1cf-59571c73a66mr14805326a12.34.1721036043742;
        Mon, 15 Jul 2024 02:34:03 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-59b268a291asm3129099a12.76.2024.07.15.02.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 02:34:03 -0700 (PDT)
Message-ID: <37c27c61ebf9e1db06a0d93adcc588fcaccec8ab.camel@gmail.com>
Subject: Re: [PATCH v2] ufs: core: fix deadlock when rtc update
From: Bean Huo <huobean@gmail.com>
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com, beanhuo@micron.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org, 
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com, 
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 powen.kao@mediatek.com,  qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com,  eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 chu.stanley@gmail.com,  stable@vger.kernel.org
Date: Mon, 15 Jul 2024 11:34:01 +0200
In-Reply-To: <20240715063831.29792-1-peter.wang@mediatek.com>
References: <20240715063831.29792-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gTW9uLCAyMDI0LTA3LTE1IGF0IDE0OjM4ICswODAwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToKPiBAQCAtODE3MSw3ICs4MTcxLDEwIEBAIHN0YXRpYyB2b2lkIHVmc2hjZF91cGRh
dGVfcnRjKHN0cnVjdCB1ZnNfaGJhCj4gKmhiYSkKPiDCoMKgwqDCoMKgwqDCoMKgICovCj4gwqDC
oMKgwqDCoMKgwqDCoHZhbCA9IHRzNjQudHZfc2VjIC0gaGJhLT5kZXZfaW5mby5ydGNfdGltZV9i
YXNlbGluZTsKPiDCoAo+IC3CoMKgwqDCoMKgwqDCoHVmc2hjZF9ycG1fZ2V0X3N5bmMoaGJhKTsK
PiArwqDCoMKgwqDCoMKgwqAvKiBTa2lwIHVwZGF0ZSBSVEMgaWYgUlBNIHN0YXRlIGlzIG5vdCBS
UE1fQUNUSVZFICovCj4gK8KgwqDCoMKgwqDCoMKgaWYgKHVmc2hjZF9ycG1fZ2V0X2lmX2FjdGl2
ZShoYmEpIDw9IDApCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybjsKPiAr
Cj4gwqDCoMKgwqDCoMKgwqDCoGVyciA9IHVmc2hjZF9xdWVyeV9hdHRyKGhiYSwgVVBJVV9RVUVS
WV9PUENPREVfV1JJVEVfQVRUUiwKPiBRVUVSWV9BVFRSX0lETl9TRUNPTkRTX1BBU1NFRCwKPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgMCwgMCwgJnZhbCk7Cj4gwqDCoMKgwqDCoMKgwqDCoHVmc2hjZF9ycG1fcHV0X3N5bmMo
aGJhKTsKCk15IHN1Z2dlc3Rpb24gd291bGQgYmUgdG8gbm90IHJldHVybiBoZXJlIGFuZCBqdXN0
IHNraXAgdGhlIHVwZGF0ZSwgYnV0CnJlc2NoZWR1bGUgaXQgZm9yIHRoZSBuZXh0IHRpbWUgdGhh
dCBkb2Vzbid0IGFmZmVjdCB0aGUgc3VzcGVuZC9yZXN1bWUKZmxvdyB5b3UncmUgd29ycmllZCBh
Ym91dC4K

