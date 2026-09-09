Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A185492E3B;
	Wed,  9 Sep 2026 00:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788914840; cv=none; b=ewNND25p4k3UJbTC/weqSMxLlWGX+fBOgmWAR7DcLvvpSlU/uhJmQWuJb7Fc9J0f8u1vHLnD5iXe9TRgBL/4zIaN3NKFDwy+SwsjAU3GRehZnl33SRW9EoYHTjJ4IGBugl95+xSA1h1zYELflerGTZ98b44SSq8gXbzd0z5EnYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788914840; c=relaxed/simple;
	bh=Snw3H5LDzEA/Bsdd+If0dFQHXVs6qGBvbR3usG46gmo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H6Bw5bUcyL3mlNGXkMZbr7molBkFnL8IKBsElR5uz2gjz5MOAFQ93hKLcYTdMXh26dZ7KMkAp7PwcEQhdfugxRZvPt5XuJYYZgZUZ8uaq52pmkt29tqyyYejeKW5lA4ipO9/XadDxWEWL8D7KBixORjscZi2s4oCmwfb3xYOR5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JB3aqToB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JB3aqToB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88871F00A3A;
	Wed,  9 Sep 2026 00:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788914839;
	bh=Snw3H5LDzEA/Bsdd+If0dFQHXVs6qGBvbR3usG46gmo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=JB3aqToBEEWFsRclcr0cJp2qhKozsylDT9kznecDKOXSdvPJNrLDc6P+3O7D2mpdZ
	 KIE+O00BfcaprlY1xTZu8i9RAceKJ3mlZy5A6jOkTHPxGyctpexIrnFGM/dYCY8fOS
	 JLiefrq3O5yuUOzyJADc1o/rcrWoGYaVA8nL0DTWXtyhC1Drz8eJ10JfKSUEDiZGza
	 dlMHYeIgE0q4ZH3PJj5RoBi9lh4Fb0dgudVsps2GZH8+oallKOupAtHE0xEo4L3xcs
	 0djXyvzI2SCAy3iCi0q7EladxhTWRQa37wmLtvLlZbrj6MH//vLP5Ad46loh+M12St
	 sodjULPzv31TQ==
Date: Tue, 8 Sep 2026 17:47:18 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Nimal Prabudoss [C]" <nprabudoss@marvell.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "jmeneghi@redhat.com" <jmeneghi@redhat.com>, "mschmidt@redhat.com"
 <mschmidt@redhat.com>, "Sharad Padol [C]" <spadol@marvell.com>, "Yogesh
 Sawant [C]" <ysawant@marvell.com>, Nilesh Javali <njavali@marvell.com>,
 Manish Rangankar <mrangankar@marvell.com>, GR-ETH-Storage-Upstream
 <GR-ETH-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v3] MAINTAINERS: Update maintainers and group list for
 QLogic and Broadcom drivers
Message-ID: <20260908174718.18b46925@kernel.org>
In-Reply-To: <PH0PR18MB4799B6A39977C80374EA4FA6C9B22@PH0PR18MB4799.namprd18.prod.outlook.com>
References: <PH0PR18MB4799279C272F238CDF36698DC9B22@PH0PR18MB4799.namprd18.prod.outlook.com>
	<PH0PR18MB4799B6A39977C80374EA4FA6C9B22@PH0PR18MB4799.namprd18.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 7 Sep 2026 12:26:25 +0000 Nimal Prabudoss [C] wrote:
> Signed-off-by: Nimal Prabudoss mailto:nprabudoss@marvell.com

This is your v3? Look, if you can't send a valid patch you should
probably not be a maintainer :/

