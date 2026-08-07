Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A88C3E47B;
	Fri,  7 Aug 2026 17:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786124847; cv=none; b=TJ7b4S86qAPJDCW2BtCrCDJzPJb4pMy0FLpHS5y++9044MyQVJvQSdccCoVNIzth00Q5c1vIEYK9XsshsKgRzFJiYlReZxSoQ9uwni7IP7L+wFB5qX3joyB1OwtMNtRtZ4cWu22aLxEGJy2MXeVB/PPrIceHq0RA8eDws7yVH8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786124847; c=relaxed/simple;
	bh=Uw8Q6+E3xFQphczpEWYs6sLZdtUz5sh0a160SJoIUO8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=DY1v9h/I9HMENdtd6VQw1UC7H7jB4aLvwRMVTFUXoGgO7XlyC8AITCtZCA90/1rx9/vCCZ1anDCWY+CA0TWxD5KUsTYGMQFobZUhdamo4twnYWl95AyN3mu9DNdS4vFxbDkCbR6QM2ZTbMazIGZ7P1kqGHl+imy0iHQ6PDXn0ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dcQFw1cW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dcQFw1cW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6CB1F000E9;
	Fri,  7 Aug 2026 17:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786124846;
	bh=4c/PVG90wYx70OAW884F+wje1oz+3IQDeU3Zt8LJK/k=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=dcQFw1cWddw1IK1fmWEy4m4DqHA9wGbI9xb1uFRO5Hgdq6FFAR6av8pXQ8SjqK+fP
	 DS9XFgf+Za7JYQhIWEZLNWD6RTivOjF8b3UwucRMcIIOnmGv3RyZWK9SuyjiLnhDBu
	 UwqN1aLlZvpyAnrD/NFNTjoeUnRZqJ6dZC1nwVSl0WDGF2e6HtmMM6GmXyMKarNEli
	 eP5uJAUv7WOnzg3UCTrTJkedvn5yotXInf6Lf1bT3O2QfS09kB61jIuqrNPtqrIlg5
	 ynHxXkFojCQW/rSxGo7IF/LVI4Pa2sycsBohYAS0fk6wNJ7f/NyZzW48NCBASSWDM6
	 UV1dgJyUlrA2g==
To: Heiko Carstens <hca@linux.ibm.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
  "Martin K . Petersen" <martin.petersen@oracle.com>,  Nihar Panda
 <niharp@linux.ibm.com>,  linux-s390@vger.kernel.org,
  linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: zfcp: Enable CONTEXT_ANALYSIS
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260806134759.2122369-1-hca@linux.ibm.com> (Heiko Carstens's
	message of "Thu, 6 Aug 2026 15:47:57 +0200")
Message-ID: <yq133wp3jry.fsf@mail.kernel.org>
References: <20260806134759.2122369-1-hca@linux.ibm.com>
Date: Fri, 07 Aug 2026 13:47:24 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Heiko,

> Enable CONTEXT_ANALYSYS for the zfcp driver.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
