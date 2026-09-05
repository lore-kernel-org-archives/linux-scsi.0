Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E4B27FD49;
	Sat,  5 Sep 2026 03:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788578971; cv=none; b=BDGKUPEvxgujzvmjm1DNCogzYa1vWKlTFAFCW0+AzqTmXI4As48/x6V5FiVrTegI0dGpvEJY65Cxl+kSxEKe7Jtu2ALIjoRgwRw9tk+pKhY3YjMQSUpyzQDaRySV85WB7tHpVAaV4c5tUV8kv/V4gmOJkoPnW7KkOU+ccrfh7uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788578971; c=relaxed/simple;
	bh=Ibae0VCF7zt0yRbMjHJnZOUHYfAoZzDXRbag0nBEPds=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Jrf3tqzNd5Wq8OCCelJrg2ztCQ/0Ky7U0TXZy9S69OmPMHJcsTDfpqSUMWmhbhE8aHhcVjlYKzsrrRkB7hjUUeNVDa0hxxVkja1IIjnY6HRxOorRpuIHCKpn8M70CE2YZZyb0lmh8kLH7YbDVdJRSswEKF0L5DOnmMGNlAREaZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fgvKcAFO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fgvKcAFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60FC1F00A3D;
	Sat,  5 Sep 2026 03:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788578970;
	bh=Ibae0VCF7zt0yRbMjHJnZOUHYfAoZzDXRbag0nBEPds=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fgvKcAFOCWP7e/dFsxCf4y+CYgSfSnduKAhHs86rCvt0Eofegi9gxl8nXqsukfLhe
	 Gmfz8goBZ23NEYXyNqwM5Guo8z7ygx6fQpBFUxR3KqYr6HrITXmeTMui9SxTjDcFg5
	 k/81NGWANCU8dnS5gVEbKl27uy5KB6/XSl/MQfIlf/qZIrssetIbYQjsGVIBaQ9pJt
	 bVlAxLZcsciukIXdzSVU7qTddD9FXtGNmp3oAu0d4TQPHd+8qdSjJgOP+3gTs2Asi2
	 9MSQW843xQO6My23yaZGeM9fO63AKZF09ofsp8TL9j+SKsU80YUXVCc3PXBxPIBMvi
	 pdWnc4OTfCAwA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 03/40] scsi: constants: rename internal struct field
 names
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, dlemoal@kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260905032224.509860-4-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:29:29 +0000
Message-Id: <20260905032929.A60FC1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> To make the code more clear, rename the code12 field of struct error_info
> to the more natural name "code" and the fields code1, code2_min and
> code2_max of struct error_info2 to the more explicit asc, ascq_min and
> ascq_max.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D3

