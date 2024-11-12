Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9794502F
	for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2024 05:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731390504; cv=none; b=DFxAXOAOkUYpYaEnGDp/8H11JHzW+Y66pKCvr19zihKKHjGQ2LVtR8O3nlJMc+FZCBYrKwuLYwqOvyj/q+FvAFachZyH4fPCg8cVJ3ZcoEmNpbvd6adNGbV/PxWbPcamtzbYegWM8b1S0WFeMB1NWRQ2DedmGer9V0WkTdTrBp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731390504; c=relaxed/simple;
	bh=Zdpp9pCE9wcVoiFZNqjd5BvD5edLdgaEsIxR6s8+4lQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cNorqv30wgYPV7jQ6b0wDSmfqSmK0iGcTQDP0R1BK69p0KRzjJSOpXNcR1SOtWSprmCqULcMfkkuBVDBJ27P7vr8IJgmXcQaQslZdBN1m+SX9dgwpBSiSK1w0B6AGVhbwdb0eUpqnyE1cLuuRHML2IRRrRsiIoicWLZPhePh+lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z/gf3kbT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z/gf3kbT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HqvxUB0Rg97AufQH3/BxaKuR+N7nxfBX1gplEIpgLoM=; b=z/gf3kbT9R7sZVS1N7pX7BaDCA
	LvBcZvyjWCsrJL5IVGqd8veibvabujp0XjQUJLpn1PcFSJiREtoRglo09S4eqthR0IMp8p4l7WHzi
	Mlu5yOg1shN/egONnmUWUYVKK5TIS/oHBg3eGAtI3GnhVeup8kDVun1cVtoQEezUCWfJ14eXCTcFH
	LZQrIII9BxULyQEzsrvNQQslxOwAXtOnTU5HsNV5XI+me6eE7fwEpApBPEFyzwyOxMEUudjQDku/J
	jIk/J2gOpSCqWSqXMV0yzaFQzdtvdq7P0bFjq5xR457bTWKEBuJMaXf48+Hd33eDtJG3lqT5EcuRj
	h6u48S3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tAjlG-00000002Hvw-2JIv;
	Tue, 12 Nov 2024 05:48:22 +0000
Date: Mon, 11 Nov 2024 21:48:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Magnus Lindholm <linmag7@gmail.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com, hch@infradead.org
Subject: Re: [PATCH] scsi: qla1280.h
Message-ID: <ZzLsJlfzCiJ1iEna@infradead.org>
References: <20241106225455.2736-1-linmag7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106225455.2736-1-linmag7@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Please write a useful Subject line, e.g.

qla1280: fix hardware revision numbering for ISP1020/1040

On Wed, Nov 06, 2024 at 11:49:57PM +0100, Magnus Lindholm wrote:
>  Fix hardware revision numbering for ISP1020/1040. HWMASK

and the commit log shold not be indented by whitespaces and wrapped
after 73 characters.

