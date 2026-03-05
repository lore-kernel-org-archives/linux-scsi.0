Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1131535DA4B;
	Thu,  5 Mar 2026 21:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772745952; cv=pass; b=ICkwuJKVzIjK33B7rmZniFC0hr6tDjwmSTDkbMLiEf+cOI15V3jbVxYM+Dpa5aP4xyWaVcmdYK1/Pw3v1EuLtUD9/xdiyS07vkS1lIde7K6ajxaUdqX/ne2qsUIaLw6Ze0shMo4o640iRvrlS4NoA/Ngrb2RPOYMat5bd92iJr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772745952; c=relaxed/simple;
	bh=B96YXaiAaxoA73Rer4Q6nx5EIeBr0eKdWwCrL/zj7yI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mgUmEQDB935mOV8SfHL9ObBbBSMyC+hVzd9efP/d6p7VdY+qBu3GrouVKymkKV7pJ/V7DQJh2Bco8Dncb5QPpGHYCXNbjScjXDJUvQm5wOTxjjF4FZ6GEIqbdXyZ/cfFGq96S1r6PrgxOvyC8eaodk2YmFcVPrIemXAI+m8rx70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=eOMKI9uJ; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=VgiQ5H8K; arc=pass smtp.client-ip=85.215.255.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="eOMKI9uJ";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="VgiQ5H8K"
ARC-Seal: i=1; a=rsa-sha256; t=1772745932; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Qggls/tkTkrtgYKv1f3jw3VPKRGepHLMz0LkIeN7xJ/V+cfI3RJQs0KK28B6qRhWMi
    L5Nb6STsLtncw2EYRn+sVmmln3wckzvcZglHnHXvsrc2AqzPlOc4Ur2IwGeTx1nFFWnm
    dXa7n0VbWDaou/0ROYZ1G8H6Zv7HAMINfW+q3l/J4BbwqCmb0FhxsSg6XqkNhpxPS36S
    rrOMrb9Esc+KxT5hT+xVYXTE7yRE7DaO1lfPBxhDsNZowrZHPrkWPq1Rh8+g4pLf59op
    8aeiKHXDnLMXFEJeulMM6zQ2F+ueACj8IeM01nNhMqbDhsbBgM318dvlJEBhIQPK9f02
    mrCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1772745932;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=B96YXaiAaxoA73Rer4Q6nx5EIeBr0eKdWwCrL/zj7yI=;
    b=sP1mDvXQegM0mqZl5x0CjUiSbKKVrFdfGKy+hinE/M5C8GjZw9jknOs5rc3FvCEh2N
    6HG68vTTS4GccirtC0jwxvN+Evy0pYyF2kf9DIBC7y5ezdOR07LL27SDfw99JHyVfXCZ
    kqtKvDnn6U45jaES7PDvHbwZnvjMIXPP4xZHGyulVxM4xwKTvPKyd7iDW6Rrr6vG8qQV
    c0HslMq/c3shgsk6HdOfcSy8qHJqOf0FC2cIpE80PRfHRLOlMMCX7bWLV3lfyen2nKCI
    1kle8QMMVaw10Y/PIckwyQDHAltDyfp40zIcqU65nXE2LNaowhXzQtQCSMNXrV4BiLD3
    j1lg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1772745932;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=B96YXaiAaxoA73Rer4Q6nx5EIeBr0eKdWwCrL/zj7yI=;
    b=eOMKI9uJt7r5tINg5AVcITEKw/njC2zv+OsOciikB3AcwzLMQXFj5qhHkx0UEX9Pf/
    91LTijjHNP9wgXbImDmCDSx1ozdaS2+K0KRMkMZ2RhYMuG9dqjoRy9y8rBrx7ipypwx5
    0/TKD3RzK3pAcc5ga5FkIolg4BeKCDkUUN2E3L7aI0okBytuGS5zmIvZdaJZapCUZYmp
    NEeg7/IyQRbOjwS1DdRv+prh2r5tYnicVh5U9viyMJr09hP4fkRuEvFoJZOILh9yFnOP
    YIHa1WLG5Ah9CvQszv3K3viCdIYHw9iubmHDgh9jDo6cIu18LsG1DEHM/fREkyqYMeqZ
    EMCA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1772745932;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=B96YXaiAaxoA73Rer4Q6nx5EIeBr0eKdWwCrL/zj7yI=;
    b=VgiQ5H8K1Qj7fu2m4iMQ2dqGGixgFVXnJ5OJzYLZB9bgZcS9mYZQGnuq70ubNNhu46
    /nr8a/c+vecaEKbV1MCg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGSTpN/lG4EkH1OcwzJ11G3m+XGf4kwpD3TrkAw="
Received: from p200300c58703fb9bfc647aebea4a424d.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z79345225LPV7Of
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 5 Mar 2026 22:25:31 +0100 (CET)
Message-ID: <44a6132c569d477c0e4809a91ee30064ddd725e5.camel@iokpp.de>
Subject: Re: [PATCH v2 06/11] scsi: ufs: core: Add support to retrain TX
 Equalization via debugfs
From: Bean Huo <beanhuo@iokpp.de>
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 bvanassche@acm.org,  beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
 <peter.wang@mediatek.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>, open list
 <linux-kernel@vger.kernel.org>
Date: Thu, 05 Mar 2026 22:25:31 +0100
In-Reply-To: <20260304135313.413688-7-can.guo@oss.qualcomm.com>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
	 <20260304135313.413688-7-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gV2VkLCAyMDI2LTAzLTA0IGF0IDA1OjUzIC0wODAwLCBDYW4gR3VvIHdyb3RlOgo+IMKgCj4g
K2ludCB1ZnNoY2RfcGF1c2VfY29tbWFuZF9wcm9jZXNzaW5nKHN0cnVjdCB1ZnNfaGJhICpoYmEs
IHU2NCB0aW1lb3V0X3VzKQoKCnRpbWVvdXRfdXMgaXMgbm90IHVzZWQgZnVuY3Rpb24gYWx3YXlz
IHdhaXRzIDEgKiBVU0VDX1BFUl9TRUMuCgoKPiArewo+ICvCoMKgwqDCoMKgwqDCoGludCByZXQg
PSAwOwo+ICsKPiArwqDCoMKgwqDCoMKgwqBtdXRleF9sb2NrKCZoYmEtPmhvc3QtPnNjYW5fbXV0
ZXgpOwo+ICvCoMKgwqDCoMKgwqDCoGJsa19tcV9xdWllc2NlX3RhZ3NldCgmaGJhLT5ob3N0LT50
YWdfc2V0KTsKPiArwqDCoMKgwqDCoMKgwqBkb3duX3dyaXRlKCZoYmEtPmNsa19zY2FsaW5nX2xv
Y2spOwo+ICsKPiArwqDCoMKgwqDCoMKgwqBpZiAodWZzaGNkX3dhaXRfZm9yX3BlbmRpbmdfY21k
cyhoYmEsIDEgKiBVU0VDX1BFUl9TRUMpKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHJldCA9IC1FQlVTWTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdXBfd3Jp
dGUoJmhiYS0+Y2xrX3NjYWxpbmdfbG9jayk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGJsa19tcV91bnF1aWVzY2VfdGFnc2V0KCZoYmEtPmhvc3QtPnRhZ19zZXQpOwo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBtdXRleF91bmxvY2soJmhiYS0+aG9zdC0+c2Nhbl9t
dXRleCk7Cj4gK8KgwqDCoMKgwqDCoMKgfQo+ICsKPiArwqDCoMKgwqDCoMKgwqByZXR1cm4gcmV0
Owo+ICt9Cj4gKwoK

