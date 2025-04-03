Received: from bsdbackstore.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D74035942;
	Thu,  3 Apr 2025 12:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743684077; cv=none; b=mL82SxvN/VYBVJNClEP8eGI3cT04o2xdBFBf4U1E4ufxD2vwy99kzELFkq3aDHIIS9Q2361Mqqbh+4U5nmibEgLO+kTcX2iQuoHgdc9lT5V8mXY08fSgAxVQOCSoL12Kt25WRGlDXuvm2MlB47DXZeZAmVQpz49vVdPUt3yLKOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743684077; c=relaxed/simple;
	bh=h+z0w691K1Gi4b0sMDZlOucg6jxt58cF3u3M7yutf3M=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=J4TV+3aRX2NgPy5CZTpVpIf/pfMfQPktazrIMugckAcNnai5O3Zz0bo/EBtOyTTwbXqX++JYhrOtucVxgVFBswHz4tKtyKOfpE2d5HegjBKD4XNTzxYbr7T5qeoQrZKQt7L7Te0qcF6chH7AnemTh0xRh3LUFae48upFLCkYMUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bsdbackstore.eu; spf=pass smtp.mailfrom=bsdbackstore.eu; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bsdbackstore.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsdbackstore.eu
Received: from localhost (25.205.forpsi.net [80.211.205.25])
	by bsdbackstore.eu (OpenSMTPD) with ESMTPSA id 516c48bc (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 3 Apr 2025 14:41:04 +0200 (CEST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 03 Apr 2025 14:41:02 +0200
Message-Id: <D8X0EVZHNLR4.1U0Q80Z1B24B4@bsdbackstore.eu>
Cc: <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <skhan@linuxfoundation.org>,
 <linux-kernel-mentees@lists.linux.dev>
Subject: Re: [PATCH v3] transform strncpy into strscpy
From: "Maurizio Lombardi" <mlombard@bsdbackstore.eu>
To: "Baris Can Goral" <goralbaris@gmail.com>, <martin.petersen@oracle.com>
X-Mailer: aerc
References: <20250402201106.199362-1-goralbaris@gmail.com>
 <20250402204554.205560-1-goralbaris@gmail.com>
In-Reply-To: <20250402204554.205560-1-goralbaris@gmail.com>

Hello, two small things:

On Wed Apr 2, 2025 at 10:45 PM CEST, Baris Can Goral wrote:
> Description:

You can remove this "description" tag.
Also, it's better to add a prefix to the subject, for example:

"scsi: target: transform strncpy into strscpy"

Maurizio
