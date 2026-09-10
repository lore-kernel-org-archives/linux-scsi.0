Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F792384CF6;
	Thu, 10 Sep 2026 15:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789053791; cv=none; b=ns0E9eTg4be6oJSAtbQTiPqyQNLW9FpM7g3mt6ZvbHvSfNkjwu4vrk8n2fW9UhkLHgVx3kErHB1bXvOHDIhw6yKyR7CAfowi1qCnHyRTcUBVsklc+bORCRA9PpCdO7cALZw6Q65w6wr2E4Q2k0OFpx40F/wYsyHQMRKRnQEWik4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789053791; c=relaxed/simple;
	bh=hnWZhXwHUJSQ7slQueqP5zSAQK4IKFTOz4dsjZZNSAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EMsXu3nn0OEgvC4VUopTSsgcqY68bngaoe6l+a9SSyd1Sgi7yMw8H4zLmxZ8WoN0EwTFu0o28hn9Dc81s0m9z8UatmNjbqumrK3BRmgxzr0o8VirXYGVoeieJAI1G/ZybUTPkuhIyvv9rQuXx0pOzwIArp6uMl4GokWQqwRYLiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TPw/xgsC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TPw/xgsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C871F000FF;
	Thu, 10 Sep 2026 15:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789053782;
	bh=m0wROt3YxDKuV+RbvHS9GTMSx7Pe6Lf6m5J3ePOAiZs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TPw/xgsCJICDARGk+6yxTduN28e2JMgVK6MCLcRovk+pJD6VRY1kofIHc5SbZDmN9
	 qLzFf+xqMaMORje+HfMSwqzS/XfpDGx04phz81hds/jPGMef30xz7oghaZnAGByuQk
	 3mXraZqvPnVPZi+AJaH46nAlwSaAGoqnQggM8F5+hUSmQ9I3oqvwZ/7/mOKBGO/JsP
	 bgx7wT6Mev+S2JDDfZ5BH7ae1VMQvO127U50pPKI4dUh15PKtAq6O6YwbmQhvfZtPD
	 mbClS3JcBAAzog2RPfrWOR3rfr+yQ7BHn3kj6KRpDHJgK+Mwgb3XbT1L6U5B3CGxYf
	 DYT0Ms/qvlkbg==
Date: Thu, 10 Sep 2026 18:22:58 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: "Nimal Prabudoss [C]" <nprabudoss@marvell.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"jmeneghi@redhat.com" <jmeneghi@redhat.com>,
	"mschmidt@redhat.com" <mschmidt@redhat.com>,
	"Sharad Padol [C]" <spadol@marvell.com>,
	"Yogesh Sawant [C]" <ysawant@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-ETH-Storage-Upstream <GR-ETH-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v3] MAINTAINERS: Update maintainers and group list for
 QLogic and Broadcom drivers
Message-ID: <20260910152258.GS13683@unreal>
References: <PH0PR18MB4799279C272F238CDF36698DC9B22@PH0PR18MB4799.namprd18.prod.outlook.com>
 <PH0PR18MB4799B6A39977C80374EA4FA6C9B22@PH0PR18MB4799.namprd18.prod.outlook.com>
 <20260908174718.18b46925@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908174718.18b46925@kernel.org>

On Tue, Sep 08, 2026 at 05:47:18PM -0700, Jakub Kicinski wrote:
> On Mon, 7 Sep 2026 12:26:25 +0000 Nimal Prabudoss [C] wrote:
> > Signed-off-by: Nimal Prabudoss mailto:nprabudoss@marvell.com
> 
> This is your v3? Look, if you can't send a valid patch you should
> probably not be a maintainer :/

+1, it is hard to find anything correct in that patch.

Thanks
