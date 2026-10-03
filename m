Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBADD17C203
	for <linux-scsi@vger.kernel.org>; Sat,  3 Oct 2026 13:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791035305; cv=none; b=QlGFDlwrXIaZwudTxrX2Mjo7w5LTmmGo6nAcNsiu9jUrVNv7yRNgYU6jIhyWC8ikSVkWiaL25mFFm6Vttntd0j4s0wbYeIR6CWqfpl3tDo7oQil07anv13ykcTHv8dFN/0Rwnx+cYVFcO3fg124k1edGcqlgyJXAUxqu0yIjJc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791035305; c=relaxed/simple;
	bh=dsyeVRNNrnCACUSFu3DOi6Tui6X+xz3mLpUD0nl1vYM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=PcikVoZl01dXgAnQcit508U/W8RQvKnB7rDKKXCgUEi3pRQk/OEwjK2JYEeRdhvXHoTV9jIgMKvdKVHHaAro50EDs7DKBLEttGAMCFfKa3iEztF6+3FzGcdmIEv0xjeWdn7kmTXKgFwF71uBtDC1TBMiOuehMTH0CfMH41cP+Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZrEQflSy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZrEQflSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14ED51F0089B;
	Sat,  3 Oct 2026 13:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791035304;
	bh=Waq0/tqffBau/Z0WsFollRzSYbK9V5A7DXrQpqJ1sP4=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=ZrEQflSykaFPz0ya8/F7deXYOVPN/erbsE8rP18qiiSY7Lbvn5I1CDVePsJ1WNRnr
	 TbUzGx88ax/K1VXcXyMta5Cufc3ilBcSwR6xSOsLd45XIqAE4TPWKAj7hPEUZoUGJT
	 oFX99uxDVMaQIXi/tzKQ/DUwQZuNc1HaPYqGI8wnd4CJbD6tqLp0733hHyAm1NetHJ
	 G2AzBkTBxDzeRQeLzZQlqkX7XvJJT5d3UotoHOSqHBWlgdFcLeidEmzVJB/x/GwkSp
	 IHpXF2H9vWXYDoSCGyi9oQ3hUmqutXB5J0mgDVvII8ejXZYuEnKiolYMKlZWt1Wq5k
	 7+/IuQbDlxvig==
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
  linux-scsi@vger.kernel.org,  John Garry <john.garry@linux.dev>,  Hannes
 Reinecke <hare@kernel.org>,  Damien Le Moal <dlemoal@kernel.org>,
  Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] scsi: core: Fix scsi_done() documentation
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <9d10e1068d75c1a708b3a56e85782d651411fe06.1790359673.git.bvanassche@acm.org>
Message-ID: <yq1qzi6lwtg.fsf@mail.kernel.org>
References: <9d10e1068d75c1a708b3a56e85782d651411fe06.1790359673.git.bvanassche@acm.org>
Date: Sat, 03 Oct 2026 09:48:23 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Bart,

> Commit 11b68e36b167 ("scsi: core: Call scsi_done directly") changed
> scsi_done from a function pointer member into a regular function.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
