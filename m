Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925EA2F0C74;
	Fri, 21 Aug 2026 04:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787286821; cv=none; b=NjOvRhSoRYSTy55L+ihf8u6iGSTLMXTZ0rskgIFovVPaXD6AD7LAPchPlH9WUvMYC6PzhrztkuEbVjoxslZcd1RusH3+ouKUTjnoRzRHgDQWppD8AXyfQuRBHRCTIyEH+3LWdIwzqXC13ZvnJqAodO+LN+WjuuJmjmCurc4+F+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787286821; c=relaxed/simple;
	bh=d3HnTQ+G6Bw1s9rFTegW6T+jKyqytuaxadcnsSGLwvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTyTgPQ1erqhboIUodN2oAXe+2C8BWBOvf3J0h/fO6i9MXgWi0gVDzfnX0JsS6etzkDu29e1tK1mhAMxSKNiqWtNm1N/X3qhgkZZvVCTanMxvLzjaQBA1CVGklojAD6x5Kql5MKv0q/hU71FUDbvM4og3IGa4uubgZZTO8QZvnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OcQpex6+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OcQpex6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC531F00A3D;
	Fri, 21 Aug 2026 04:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787286820;
	bh=Xir3wmqyora5o8sBqjd0Gc58yA0omfx3/tE8bLags90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OcQpex6+VzMyIZGL5CBJQlEwrE+uaGeVqn9CBXWz65UfMtlTLtZRLp7WUnX9jzao/
	 Q19PmleK3HhosROya2OwbTjyicra99QUZT155g8WwhSGTT0k8cPMZ1KBFHiwZpCc6r
	 ejK4DVMXvgokezpv77a6gR3wzTA1yj9x3yVB4x2YxZcPxZGQM4i0X9AqbmO9xk6Epm
	 QyK+b1GH2n1oQKMxzBZnnV6W0xFF+uTB1I7NeJE5lP1el4EksIuB9UHTz+WZumYqSL
	 gyynPiiUPGYfejN7XXAAzUyrjBKF/zahrJrQFIKcZbCjRcoAW0KeMGD6iX+Nny3hgm
	 1hoMVFjURFwnA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Daniil Iskhakov <dish@amicon.ru>,
	Achim Leubner <achim_leubner@adaptec.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Agalakov Daniil <ade@amicon.ru>,
	Roman Razov <rrv@amicon.ru>,
	lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10] scsi: gdth: ensure event string is NUL-terminated
Date: Fri, 21 Aug 2026 00:33:33 -0400
Message-ID: <20260821-stable-item008-scsi-gdth@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260819093542.23409-1-dish@amicon.ru>
References: <20260819093542.23409-1-dish@amicon.ru>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> No upstream commit exists for this patch. GDT driver was removed from
> kernel in commit 0653c358d2dc ("scsi: Drop gdth driver").
[...]
> Found by Linux Verification Center (linuxtesting.org) with SVACE.

Since this driver has been gone for the past few years, a maintainer ack will
be appreciated before we pull this in.

Does anyone even care?

-- 
Thanks,
Sasha
