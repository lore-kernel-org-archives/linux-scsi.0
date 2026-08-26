Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E240444E66E;
	Wed, 26 Aug 2026 15:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787757625; cv=none; b=ZPqyFoAV2dbruXbgxxF+2Vf4rODimwZBGVagK8VJ7am1d0Pb3h51yysA6Hk6qXF+vRca+zbq6TmrMZn7Uq7l/wTtb+x721oxZXTeKyryOftXPvFnw15SlD71fnf9SgJJYvpm4d4JTBoSKMRpsbZM5+mj3eQZ08P2y1srPI0K+1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787757625; c=relaxed/simple;
	bh=Dh8MQimqz/61HHn/k5f/v7uu68jzNPBxx1Il/F46hDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iqqgFryvB1nsCFYyvGsIzDqv06GxKcSk2eKXSN2F2N4ITzy9yoYXxTNXDwxJD9VVS7ZDcy4jmpaxnN0Bbj1xLYzTx9VfswkNCPQdN7XhVP34HkEfUiwE9/NdTSQqIc73PL078y+85UKGJ+NzTDbX/6URAB2jc6aFJBai+uTycPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b2Y9J+UL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b2Y9J+UL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6ED1F000E9;
	Wed, 26 Aug 2026 15:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787757623;
	bh=aBV8XhNWJK1U//ukN3/U5x8Roxq2FZJWyY/lLDyLuK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b2Y9J+ULj6hWfDLKWC5A0b+vUOPEkVoUG+kwLc489FGtPepOdgUkDN3XohVi8Elbq
	 frjxHTPYhAPxpYpId9U4bA65wTARom7mUwE4+X7z/5ecxj6jGMx2WKZwIA57waK1nM
	 jnoIJNTO2tUx3Dg5YXOubMpOO1KCZ6auXYxnd9/rGVGQ/P+ghnV2PyUSX6n+pR4tVx
	 K0zXBodZLi+V16djkSI8RatdmIH/KlhO68YbbhFYBtUs0GqG3n4qYVPabEweX4JOIP
	 dz4P0/KxQCljGad7dGBolIOjEU9hY9j1c9ZyHPxjXdi3eYxmEUhe1ApjgK30szubEe
	 BEIxpNw4whg8g==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Justin Tee <justin.tee@broadcom.com>,
	Dan Carpenter <error27@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: remove unnnecessary NULL check
Date: Wed, 26 Aug 2026 11:20:10 -0400
Message-ID: <178775714072.3862282.3530046122422795422.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <an1trOAUeQmYEus_@stanley.mountain>
References: <an1trOAUeQmYEus_@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 13 Aug 2026 10:09:32 +0300, Dan Carpenter wrote:

> The "evt_dat" variale is non-NULL at this point so there is no need to
> check.  Delete the check and pull the code in a tab.

Applied to 7.3/scsi-queue, thanks!

[1/1] scsi: lpfc: remove unnnecessary NULL check
      https://git.kernel.org/mkp/scsi/c/0ec418204f23

-- 
Martin K. Petersen
