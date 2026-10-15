Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627323D954F;
	Thu, 15 Oct 2026 02:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792031201; cv=none; b=GhXrLQBzBBgAeC3SB4ITtl4Kcdc5cDLUv6V3NyuyUcDjFfVNVHTB9nsuZ30s64k7/2ZwhHn0WRnzXwKY+BMJksh+qnVE/Hc4DYU1ysRp7VzPWHru4iGwAwe1ub71w++CWLK+YKKr4JfzJSFKo4wVDNbilYClsn1eDWGHn/hCk34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792031201; c=relaxed/simple;
	bh=FSNUAhw4xryFddCK6JXdRLnWyPdTn62pRNHw0rV08ZQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=nAKH/7XWv2R5AOYkrP2LuV80Jq4qT91MJAIA5Ch2dl/V02ujjkFnzcdpAFQTAXOG9gQA5/Men7saZcphmgZmS7wvPPVcXOvu0QjsuZmUm7WYwofkfHUJCzejIe/YZIONTNn/oc8zX7zeCDy65Zq1hcHK4nkuZVmhpwUGa8R4xL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VfGkSQBv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VfGkSQBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93981F000C4;
	Thu, 15 Oct 2026 02:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792031200;
	bh=9XolomIZErJmb8QbGvuq7FYEzcVZ/CcquJuA7o7E+qQ=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=VfGkSQBv50fOylvLd7oPBLi90m34idyHKUYE8Od++Ey0J01FqMSHPEKtqmFHu6S2I
	 LHIw9eJfFSYW0gbuAMBtjW9qRMOrxPlfgu7UwWkJHbvA1MDzcm6CGubsV8fJyM1Uqg
	 JqwvQZHg8ICxiCpyEtkFUatxJKahUVKdpGEEQ+qrpRD/qo/mLoq2cs4jIL0wB46eXK
	 3Qd1PJrt/195ZMqiBHhATUo1+6kOLnDZf7TwBCrMmdQU08UcEkITB6TmtMWbqXxd2r
	 GPWwiH4GITSk9xBFSWb9DIQfz4Lr/+cbFAl2XSchOK/92sT4nR3IjjZbNYFQEqhqhD
	 TtD6HiqjN37Cw==
To: yangxingui <yangxingui@huawei.com>
Cc: <mkp@kernel.org>,  <jejb@linux.ibm.com>,  <john.garry@linux.dev>,
  <yanaijie@huawei.com>,  <linux-scsi@vger.kernel.org>,
  <linux-kernel@vger.kernel.org>,  <linuxarm@huawei.com>,
  <liuyonglong@huawei.com>,  <kangfenglong@huawei.com>
Subject: Re: [PATCH v3 0/4] scsi: hisi_sas: Some misc fixes
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <51d44015-cbbf-ab69-47ed-0c9b397da203@huawei.com>
Message-ID: <yq1ik33em3v.fsf@mail.kernel.org>
References: <20261009033238.1076098-1-yangxingui@huawei.com>
	<51d44015-cbbf-ab69-47ed-0c9b397da203@huawei.com>
Date: Wed, 14 Oct 2026 22:26:38 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


> Could you let us know whether this series is fine to be merged as is,
> and how you would prefer the pre-existing findings to be handled: in a
> follow-up series, or folded into this one?

Please send follow-up patches.

Thanks!

-- 
Martin K. Petersen
