Received: from smtp.eurecom.fr (smtp.eurecom.fr [193.55.113.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A045C17FE;
	Fri,  3 Jan 2025 00:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.55.113.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735865254; cv=none; b=gFZLyFNLDT9ED+w6j+4RkZuxgdT0AZaK2S95Bpbodw7Y9QPkx80m59OUFiTeNKiNRR+DeNOC0E7zPO4eh8xqPoJJl1SY2pksYzVVtj3yBclxBqToIJqL7xbufz7aVyTGgxPKLNQAx7fACnQ3bkQt1HAc3DNA9sd2+jFnKr0PbqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735865254; c=relaxed/simple;
	bh=qSAojnGac8iiWgQNm/GwymTaLAR/dOnzURMucEMiN3Q=;
	h=From:In-Reply-To:Content-Type:References:Date:Cc:To:MIME-Version:
	 Message-ID:Subject; b=kLL4yIn4KhEc/ZtlFwA7XVIHCo7IHvj87EFgRnn3sCTfUKl0gtpfZZQoCcbByq2QDscru/p5IeX6E7iyDUFBRpDtYtnoHi/iRnt1IdkWdDRFiQpftOVjlygvTFRu6D61MjsxqDewWVEoOOXsjGI4QG4JSkA+pHZ3ETbXRatwpYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eurecom.fr; spf=pass smtp.mailfrom=eurecom.fr; dkim=pass (1024-bit key) header.d=eurecom.fr header.i=@eurecom.fr header.b=LyHtmrv4; arc=none smtp.client-ip=193.55.113.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eurecom.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eurecom.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=eurecom.fr header.i=@eurecom.fr header.b="LyHtmrv4"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=eurecom.fr; i=@eurecom.fr; q=dns/txt; s=default;
  t=1735865251; x=1767401251;
  h=from:in-reply-to:references:date:cc:to:mime-version:
   message-id:subject:content-transfer-encoding;
  bh=qSAojnGac8iiWgQNm/GwymTaLAR/dOnzURMucEMiN3Q=;
  b=LyHtmrv40VKPhmH4P6eFgifYKE33qw3mlS7sGOC8xEiKlv5TRxLSSUDb
   WPXSNkf0hffjUYa5gS059bWBw/FJsPVhznVAQCTENzQoD3Zg6uwm3isnH
   WhCMRd1kFVmEFQsxpY+fEshlQg5kP63qugjR2Ctv4BUaa89FzGIr2jtO/
   k=;
X-CSE-ConnectionGUID: Qr5dsO1jQguNzUXQbgKoew==
X-CSE-MsgGUID: l0V1AArUTJyeei5hpacyiw==
X-IronPort-AV: E=Sophos;i="6.12,286,1728943200"; 
   d="scan'208";a="28362203"
Received: from quovadis.eurecom.fr ([10.3.2.233])
  by drago1i.eurecom.fr with ESMTP; 03 Jan 2025 01:47:28 +0100
From: "Ariel Otilibili-Anieli" <Ariel.Otilibili-Anieli@eurecom.fr>
In-Reply-To: <yq1jzbcde3v.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Forward: 88.183.119.157
References: <20241213225852.62741-1-ariel.otilibili-anieli@eurecom.fr>
	<20241213225852.62741-2-ariel.otilibili-anieli@eurecom.fr>
	<yq1ed1lf3z1.fsf@ca-mkp.ca.oracle.com>
	<2f7a87-67770480-d1b1-141f3260@133486995> <yq1jzbcde3v.fsf@ca-mkp.ca.oracle.com>
Date: Fri, 03 Jan 2025 01:47:27 +0100
Cc: linux-scsi@vger.kernel.org, "Hannes Reinecke" <hare@kernel.org>, =?utf-8?q?James_E=2EJ=2E_Bottomley?= <James.Bottomley@HansenPartnership.com>, Linux-kernel@vger.kernel.org
To: =?utf-8?q?Martin_K=2E_Petersen?= <martin.petersen@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <2f7a88-67773380-f509-208cdcc@258589942>
Subject: =?utf-8?q?Re=3A?= [PATCH 1/1] =?utf-8?q?drivers/scsi=3A?= remove dead code
User-Agent: SOGoMail 5.11.1
Content-Transfer-Encoding: quoted-printable

On Thursday, January 02, 2025 23:51 CET, "Martin K. Petersen" <martin.p=
etersen@oracle.com> wrote:

>=20
> Ariel,
>=20
> > Were you referring to this tree? The commit hasn=E2=80=99t appeared=
 yet.
>=20
> It's there now.

Indeed. Thanks, Martin;
Have a good one.
>=20
> --=20
> Martin K. Petersen	Oracle Linux Engineering

