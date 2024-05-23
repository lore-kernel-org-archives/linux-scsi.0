Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EB313C9BD
	for <linux-scsi@vger.kernel.org>; Thu, 23 May 2024 08:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716452270; cv=none; b=iVYaWH7JgjwBD7A1Z3frjLo385Go25O+zSqZxmBiQK69yurc0sO/PF12Be7MowCElSybV2Pch7JrzrigrlL5et2fj8RPbHhGZ11Im3s0ydq9M0jDSykTVI0yAcLKG8XvDuzr5ULIMiZDyeLuJoNtW4CSCS0BqvcalduRkog14SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716452270; c=relaxed/simple;
	bh=JrqtL4x3Z1jggO/VrBme3Bq6Bb338PKbLCHS20Z1gpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lAInHf57rjYUSinimGNEl8fs36R9HBcotJKt4jXb+gWNnUoYJu/ahn54z5Ujyb0U7bBZkuTzAGsxmEa9eIbJqufmURCXAMnFUk7iCHtlOWDMO4Gzq19lofRaEwsYURcNaXqjwwkcpO2qXT4F+ySWZJ6mwJ4tCC9k0GR8n69eyVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nQxlKfo6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nQxlKfo6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JrqtL4x3Z1jggO/VrBme3Bq6Bb338PKbLCHS20Z1gpU=; b=nQxlKfo6IAK37hkSyeQijNOWGB
	Hs+BbXUPjTtUmrnd3Kp7xulAA6Tw5fkKUAqO12AspcvfPin0/qCiEQ9mqN1qjZ5pqkWF7wj/xk8RV
	bjlOebHme4jRCzdkW57Nv+DywPp05W74QfvzzZnHAm4AY+0VGaL9z4fERgoOd/11KKWTURpx+Voff
	ERUn42FLbWV80scS7SzxBUZH6hmsMerRXbPWQsfAn81gRVumvSF1JuBRIgmQT4LZvbUR/mWNMdENW
	7KsY5F1JcjHtg6UOTEDjaS5CwWvdYsvq1GmMWgxsITb6VS7lxwcwqUQQgsIUrCoWSPTQK3PAkIIcJ
	nuC2of3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sA3dg-00000005UVV-1dcP;
	Thu, 23 May 2024 08:17:28 +0000
Date: Thu, 23 May 2024 01:17:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Cc: quic_cang@quicinc.com, quic_nitirawa@quicinc.com, bvanassche@acm.org,
	avri.altman@wdc.com, beanhuo@micron.com, adrian.hunter@intel.com,
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v1 0/2] Allow vendor drivers to update UIC command timeout
Message-ID: <Zk77mPfY5FpEszXk@infradead.org>
References: <cover.1716359578.git.quic_nguyenb@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1716359578.git.quic_nguyenb@quicinc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There is no such thing as a vendor driver in Linux.

