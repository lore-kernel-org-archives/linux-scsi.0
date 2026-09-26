Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5922D23BC;
	Sat, 26 Sep 2026 15:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790436439; cv=none; b=q/4VkrL/D0nrOjuTY9yGBpcpRBWBnXTbeog7v338PhHx3uFzLvLrbHpL7Ovug8fuYrp+S0Ty0tyVeyVTgzYsQYsRuLGtYmKo5ggsW+q2tSPFVjfNi+uPvG+l6xe+jxlaHjYzHOIia39GNXbZLbYfCyAjcvRc04yUW+gM6b9badU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790436439; c=relaxed/simple;
	bh=xsA+BfIo+zcTq7kUiJ6eKfHlQs2ZwE6gRLOjwMs21EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/ZU62CNyCRaB39v6czk6hyiDQFccdJUSnH7VERNW0pxTLTKrI7lG98cGna+/WDp1nk08IC5wALTkIC8oBXOQSv+R7kpBOE43SG52UN3IcvWHqsl/ZsMMlwTMGme5S0QGcoCDfgGSpnRlOfu4QTQL2EYRuNjBh8tqPPwGBrfOc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iygRINFV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iygRINFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE131F000FF;
	Sat, 26 Sep 2026 15:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790436438;
	bh=UZKrSyBC5OPnzRz4MuLrKAGmRwrKbC1sxfSS3sN2m3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iygRINFVK7Vx+nRdcEp6bt5dq6RMUh7nQcm99wXFJCMFcRPDCoeYnlQ/ZOb/GJukA
	 LujWRQyqbP0rQxbxJFixBk15TrsrpncVLQr3+C5yxdbn9B+hySh0ux6EHppE0Nb/Uj
	 jI93Wynf3M//kjunotId/2/ubMq2eSAlukG9vCILJtaVEHKAlVVhz5nLCkRslRXk5F
	 +W8HGINVyWIcBOibIjYmHLK+l8qjwwqU/IZg7UYqineN/Pqus7IxrYnYOeECPxWnvk
	 O7+XdE9nCSAn0zxxMtYzEd6WjP850QgsqdxTSvbif+etPVDwUsw/6OhA+rT6Ifl+rJ
	 SR2fsoB76LwNQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Xingui Yang <yangxingui@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	Yihang Li <liyihang9@h-partners.com>,
	John Garry <john.garry@huawei.com>,
	"James E . J . Bottomley" <jejb@linux.ibm.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1.y] scsi: hisi_sas: Grab sas_dev lock when traversing the members of sas_dev.list
Date: Sat, 26 Sep 2026 11:26:58 -0400
Message-ID: <2026-09-26-daily-reply-0005-re-hisi-sas-sas-dev-lock-6-1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925195622.31558-1-artem@trailofbits.com>
References: <20260925195622.31558-1-artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This is the 6.1.y backport of the fix for CVE-2023-53627.

Queued for 6.1, thanks.

-- 
Thanks,
Sasha
