Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FFF230BE9;
	Sat,  3 Oct 2026 22:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791066849; cv=none; b=mZoPwMwPIy9+6VpUgs906lKQQntc3EwOKyb/DHVhB9yNL5ZcE9B6c0XlEKSAPmtRoexhWxTzrgsZXKxEHlglvBVOQy89c00EHcdGccfTJ1g9pj5c+Sg6YSAJjzqU29PaGc8TVpW4IDXTb1SLrlMKA5AiQORhysxsA1zp2xlIPL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791066849; c=relaxed/simple;
	bh=hxxBMAOt5jXNikGAk0poKDKwv960fePiQwNQLxJH9Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qs7Ybvg+/OYtBHwrEdg5cjrDn/pnfYIrymNRI8/wVGzH6homSBOPrRwna+njj3dpD9egdG+288wki0p0eMApGhuzoUfqaFlrMiA3spulKiLblzGuzjarl+fIZO499AzdU8rRLx+hRjY7JcSIWC9ve/TQUpjqDib7GsCB/45K3l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aRpxNkPz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aRpxNkPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4634E1F0089B;
	Sat,  3 Oct 2026 22:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791066847;
	bh=YOx3vCpcAilrUVJ7WwyvbK6QC5yasslmRGwaNNYkn+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aRpxNkPzzgz4J98cYz6jeL0vYJSWhvCv4TI9z9yKSjdArx0czSMs94cznXBvaT3Fa
	 cWtGj32ZhQCYp2VBbJxmzHmYgp5jpa5/dUiQCst3JOSJqb+qJ7t8ZM0k3xcGvyxbIm
	 xxztypjEE9PeHeO64LLoP0rxwQnxM0lfD1+d0iAyIwG77j79n/RbDmyAFr4ZO59Lel
	 BVbTiTNqI6Qo9nR8AFmb9zQbXyTRR0sOTgWYL+ibzcMAqJHCBv59JAzFw+4XnDIXEE
	 UG2wUyugmq93xLzpQopPrwMBKrUu49jNOEiJSsJa49dsjbhg7SxhewPutGi/wF8yGD
	 pNx8BHlW7lRSw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	James Bottomley <jejb@linux.ibm.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Martin Petersen <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.6.y v2 0/2] scsi: lpfc: Backport SFP mailbox timeout handling
Date: Sat,  3 Oct 2026 18:32:48 -0400
Message-ID: <2026-10-03-1-daily-reply-0007-re-lpfc-sfp-mbox-timeout-v2-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002182205.11550-1-artem@trailofbits.com>
References: <20261002182205.11550-1-artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Could you please queue these two patches for 6.6.y?

Queued the series for 6.6, thanks.

-- 
Thanks,
Sasha
