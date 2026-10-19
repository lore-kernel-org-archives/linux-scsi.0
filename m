Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E9A35E937;
	Mon, 19 Oct 2026 13:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792416561; cv=none; b=LrzuK4lr5B9Yf9xsNw0VRAdMPXWdmHydvPlejBTxa3pOREzjh0DP0XQURcUQvkgYKNjWkABNWwFOYN2V3thX0jr4t7fg8Zx2VzijFuKQLaiOwyStD7TtYEi/Kdd1a4hATjfoAnRXzxpscWZvygKCgvYfp5xEftQhAaVgVbxfkVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792416561; c=relaxed/simple;
	bh=DxOA3K04TdGKgV9RBzwq7NMB042SfZvdvrNpiga7nYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MSlG9Puwvxok4Iw7he8VraXQnfwg2BEpyi9hd9E0XnvPy0nwR4In76rOmJbrVDfzg6P3jqfyefeKP1V0mkovtLNhyAfftDPbG1RHQdpiwwc4I+lkClZ/X8L4EyLqYO+pgOqVq8S2qhYk4h6kZN6VJD6NUOqlkeJ+DdSThQ7dcXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cg8kmesW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cg8kmesW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC541F000C5;
	Mon, 19 Oct 2026 13:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792416559;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cg8kmesWN57mHmnl0en3kWYMO2yX0BgIRJzmq3FgiPIVkBHJCehyWohK/DQhrOEJy
	 zJ545bTFLn74AXk4TK9iv4KqYQvZj/aULQzo3I9xAoccx+xnbNmrrny1YSqoudqAqC
	 3t5pUrZqPQlIPOy7v9hANSTAMWsvK/nWshybXQj4HrMlb82PZDOAptKJ80fJhrkkTX
	 wNbWypmgc1cWREAxmVJ4bDCxM4fm1RUbYpgiRmnELaMwuxy7BMgsE5pKMipz6Se2Nd
	 irGKYFbN7VB6z/DugXCGWjA/4SWQSWoiCRXgiwnDkvgj8pO4A7CkPIUrUiPolEqqpY
	 XI/4AyHot2C3w==
From: netdev-bot+sinfo@kernel.org
To: Haoran Wang <haoranwangsec@gmail.com>
Cc: Varun Prakash <varun@chelsio.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 linux-rt-devel@lists.linux.dev, linux-scsi@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libcxgb: use raw_cpu_ptr() in ppm_get_cpu_entries()
Date: Mon, 19 Oct 2026 13:29:18 +0000
Message-ID: <179241655890.3290.16297373218443125626@kernel.org>
In-Reply-To: <179241614797.5916.13928836073297916808@whr>
References: <179241614797.5916.13928836073297916808@whr>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
