Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAD136605D
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 02:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789006236; cv=none; b=HB5BQhcQAzvQuPqG6D+5ps+6lok9wy2siY9NTdG5te8kwgKqQ+/LL3E99rFpDOVkOzsdAKKanm12U/Z9RGOk67/J9s99RmJ9JevV0x2yZfiq0SNoOWXVTQTKlDp/oj4M9Zpw1J+yTTe1/EgnZbHfzXfZeN6lpx+neb/UsvJW050=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789006236; c=relaxed/simple;
	bh=vTaT4XC+fZEV825WQ62HOi7IMA3zBFYx6P8GvMSQzYI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=GtjKwt1veq7gNlBGS0OhBN6XxYtEHgJeiDUx7TKPvOvct/6zD2qxSc0B1PJypaADx6Sm9lz2zTO2YwW2ANljoMXEzhuo1NVuiyg1Iq2PLr3zx/eTb14R7q9HyGqnjMdRy0YIhrb9r/J3vqG3WxZJ7ZPgCDWvwGpMpQYWiBzmCio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GpUT5ZfB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GpUT5ZfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5411F000FF;
	Thu, 10 Sep 2026 02:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789006235;
	bh=qHc6hC50yhkgjhZhZp1/gcna46dd/+0/sJ5L574C94I=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=GpUT5ZfBTPNcYemuVwa3SeRRH6oMrPefaf5iGtU/FCjAdUl1jZQRO9V5H6aHx+/cs
	 4kaNaM9+iD4ti7yXo+ToPEXt/ITuroHClZJfnnQ3AWba16sIEM7ewlkfC+/TfKEIxc
	 unN4kNsSr54Wd9antuEsyqWg5i97n1x8feS0Yi7QYt47RkKxb6kQ/S67Ga+laZEmGp
	 sxVLlQ9rfb2rvfb7iy4ygwa1xfh9pev4QJ31/Nu51U0sIX60GpXaVjaULtG2SO4c+P
	 Z9mccEfTo8cq8lxP0bo/EfM0Lo9ZLjapzYPGnaXgcUcgk3ZyAcqUaKE3UZh/D0/d70
	 hZkB6J5d11jSQ==
To: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org,  martin.petersen@oracle.com,
  sathya.prakash@broadcom.com,  ranjan.kumar@broadcom.com,
  sumit.saxena@broadcom.com,  sweeti.vandure@broadcom.com,
  vishakhavc@google.com,  ipylypiv@google.com
Subject: Re: [PATCH v2 00/17] scsi: mpi3mr: Fix out-of-bounds accesses and
 reference leaks
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
	(Chandrakanth Patil's message of "Wed, 26 Aug 2026 02:33:54 +0530")
Message-ID: <yq18q59c0wx.fsf@mail.kernel.org>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
Date: Wed, 09 Sep 2026 22:10:33 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Chandrakanth,

> This series contains a set of fixes for the mpi3mr driver:

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
