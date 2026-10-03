Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EB0351C0B
	for <linux-scsi@vger.kernel.org>; Sat,  3 Oct 2026 14:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791037506; cv=none; b=kXDLtPsoO7LArn+c7QW+oZ9Wu69ccG0/f+YEZHr++ng4tgxPpAkoZRteL5cPSo4vrAQUUh+nx7LF8KudLnR0BDPOH2gRFBIZJUi0N35Ode3m9eM+soj60hwUls8yzvTjGRnzkwOPG2wGnjK2b7gIvOLrDhtBNFjLAYJ1/Fh7CkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791037506; c=relaxed/simple;
	bh=XVJGuY88HnKqnyR2bOU0ZVMNbAp0hd7Jk8MVCp+Ijrc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=Hcj1/S2KH9NHWlQnWaXLffwqAMDDr5GYBJS3UIdpZKBn7027jOlFI4FzMF+IB1fEdWvF1nY2vzQxh/2Nc1wi8e2QzDZXhv+V/jlmTZYtI2VlYCPgzD7jLCaBKkv4q0OtUGZ+HVSo5SPAi7vim8BB7hG/neWZK2lkvysGSKehRT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m1vKdVF4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m1vKdVF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C311F0089B;
	Sat,  3 Oct 2026 14:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791037499;
	bh=LJ+g/0Px1EsabRp6fYWPy5ZSQ4jMVJlUmyzxQXVTnZQ=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=m1vKdVF4VuSc1vyFUu+mX08EwSc6bc24v7iiAgjORU13qdfacN5frEAJNv6PwRzd3
	 7EbtMWHnsY2c0SgbtRDq9NCYXZn4aG17jgpTzHa9MoSs5cFSBkRTUwEgCKlYC/Ppmc
	 zoroxZUoi3Ee6e4rulHH3kV5Mz0HtI0CE9yJGMM2LwIojOvpVtaP0NTBfwgJzQ10l3
	 LXkAAUSwmTdXA2l5A4F7euvI0v+u1QASpYZmoVj26MYcaTyAiTprMeEwXicSfAtqGX
	 4ie6OTY6skoURDEx4VbzKmi74scch7Eei4DGYFtPyp3Yf3QiCEFlnLWW0KtvtsQd8D
	 VAjwn4lkEG4Iw==
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
  linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/7] scsi_debug: Enable lock context analysis
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <cover.1790723966.git.bvanassche@acm.org>
Message-ID: <yq1a4oulv5e.fsf@mail.kernel.org>
References: <cover.1790723966.git.bvanassche@acm.org>
Date: Sat, 03 Oct 2026 10:24:58 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Hi Bart!

> This patch series fixes a locking bug in the scsi_debug driver and
> enables lock context analysis.
>
> Please consider this patch series for the next merge window.

There are several conflicts wrt. Niklas' zoned write series. Please
rebase, thanks!

-- 
Martin K. Petersen
