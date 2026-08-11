Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B226937F727;
	Tue, 11 Aug 2026 01:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786411564; cv=none; b=aElqKyoXW3i0lycJ1qnnNzRnjdF1VmgOSqiyzhLa0CU82rSYKk7ML/h8exd8gPkMJg0qwdUoTvBAsUJDkrpXpR29JluIU0SoWmLgGl4LXlCuWyeEOwQ/dFHaLrVhqvna1TGsvr9tzOIXsK1JswNqMYj7CWFJLJtB/6e46z+pAJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786411564; c=relaxed/simple;
	bh=BGLpnE3xgDheX8oTIsp3EbEhk7oJln2dbgtrZtiP698=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=eq06DXeMo2Z1ljR4cFwbG0K7OlfmcaQLJcYvAyXMj35mvM8DfXqDndj95JTIF5LStxJncMiJGz1PQno7ASRvQoluAeEBRLHXudw8aL97wllY5UcmX1m3lbDhVSNBImLodgLwgMj0SeMXslDJnMmoe7MJZBe1jezU+k7+gzY3wCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UoItw0P1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UoItw0P1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0195B1F000E9;
	Tue, 11 Aug 2026 01:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786411563;
	bh=uRleJ4eP/gnxUnbEgZpawqofU5wZ/GfdTOV4jzbOjc8=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=UoItw0P1Wn7707HEIrCZ9ftvL2eOzi2ccUGIIWHivetEQtJ/zzlvWrS+lID4doM3H
	 +batf/ArbRwkoz3gh314qNMl5BdD+zy+kiV9ndZu79VdGc3ZpCjrgnn0SIx19sWpNb
	 uOAJOMV8ORngRUQYYOSAbqbGw7URxAZoSuji3qPFBdDsQY3jcb+l5ZWGCarWM39bD1
	 1DgenIZH1pQV4nTXV0RgXLX9JN2RHDMUMhpApblniCKp1z2pkzzGx1k5i92aNC8GtV
	 /d39aTcghS2V7PAReo2dRQs0yDVMtPgvjQ+JAKEV3WIj7qnwZBnXMmqqvyKMehIh4k
	 MPSgZC7Rw2PSg==
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com,  arulponn@cisco.com,  djhawar@cisco.com,
  gcboffa@cisco.com,  mkai2@cisco.com,  satishkh@cisco.com,
  aeasi@cisco.com,  martin.petersen@oracle.com,
  linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org,
  jmeneghi@redhat.com,  revers@redhat.com,  adakopou@redhat.com,
  lduncan@suse.com,  kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] scsi: fnic: Fix built-in NVMe/FC build
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260810110627.4521-1-kartilak@cisco.com> (Karan Tilak Kumar's
	message of "Mon, 10 Aug 2026 04:06:27 -0700")
Message-ID: <yq1bjb9xxbp.fsf@mail.kernel.org>
References: <20260810110627.4521-1-kartilak@cisco.com>
Date: Mon, 10 Aug 2026 21:26:01 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Karan,

> The fnic NVMe/FC code is guarded with IS_ENABLED(CONFIG_NVME_FC).
> That also evaluates true when NVME_FC is built as a module.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
