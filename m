Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E163313E03
	for <linux-scsi@vger.kernel.org>; Sat,  3 Oct 2026 14:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791037419; cv=none; b=GIXvUBY/HmTCbZ7OnfyhZQ7ludEL29HSlmBJHLCbNAHtX9ABjyvk6h6vbc2XeyuzkyCKHUabvluC+S4654KpMGDTY2xC6zo5PXNCQmUloRHob5sujEJE41jH2Ai+WzTcp3VaBye+UNivzoOGsp8lUpfWkkE2+ahzOXpT04TXdgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791037419; c=relaxed/simple;
	bh=9Hi69buQpU5lBEkm6eflgwggAf9w6QPnYpbMzZily5g=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=Tx2Y61m2EX+SxsDxdh7P2bS8cdRDsElOnLDD44wd8VNk7o9v9HZKNw5Z8+eWBRBhyOS4YbCffGDxLldZ+LEuTt+0OSpH7BVLRYhyCU6aZvTmzuBOxasjjQ6qoNiv78rtqNsCwz79+/j5TeTyXTC7nDbmbyFJFyuNvBEPjYWqI9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VTmGZ1HT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VTmGZ1HT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693651F0089B;
	Sat,  3 Oct 2026 14:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791037417;
	bh=NdCEXmLha3vvFmN15VBFKXKnCxqhyFC2XYrs8imQE88=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=VTmGZ1HTHoUC70tuY0b7WgV0pnPQzSQoMOON5DGpHJ6XASs4c7MP66giSpSqJ5ZpA
	 KJIFGCXyf01jbDk+8/qs7ez7JzXxnbgFy8HoxxGKymZfC5nV6RPeqRPIE2II9Q5hhb
	 IeWRDDNWL+Ucll1Nx5G6zoVGFyCT5++xWPeyKVdrFFF6KL78i9JCGIJZwo6CossZJG
	 Amvzh4uxbX/P3RXMItLvfb89B/7UgTt4DZ/QqexJj58vlXF0e5y68hN78YNTO8lUX2
	 u359qUomvz8yC39jb31vgBC0E8540Wjcg6Lvqubl14mBE+/3StaXsGoQXG89YACjdw
	 Q5KvoVi6NGSYQ==
To: Niklas Cassel <cassel@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin
 K. Petersen" <mkp@kernel.org>,  linux-scsi@vger.kernel.org,  Damien Le
 Moal <dlemoal@kernel.org>,  John Garry <john.garry@linux.dev>
Subject: Re: [PATCH v11 00/13] scsi: scsi_debug: fix zoned write validation
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260929082456.857423-15-cassel@kernel.org>
Message-ID: <yq1fqymlv6q.fsf@mail.kernel.org>
References: <20260929082456.857423-15-cassel@kernel.org>
Date: Sat, 03 Oct 2026 10:23:36 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Niklas,

> This series fixes scsi_debug with regards to writes to a ZBC drive,
> and to WRITE ATOMIC (16). Each patch describes the problem that it
> fixes.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
