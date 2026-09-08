Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E84654EEA1
	for <linux-scsi@vger.kernel.org>; Tue,  8 Sep 2026 14:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788878033; cv=none; b=QPK9L1WPKbGxu2G7QyzgHy71weoWQuyTMgq1sb4tFn9RhbKbd8vy+0YBXLskqZhgPKVLihWsPoT0/CFeSrbhj9rmxTvUEyAOEkibFubzEl/bgt0plmYrF2aGmO5XPCiSLPkgkdifuxyI9OPDEylKEVELmDvScjEewGNo/adwrXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788878033; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=MARDDwNzQt3gpZ4isFPInW3DOGU5A1Jm8CFwIRDrujQGMJsTA5NzzY9JE6B+oTpupQk21TRsZJ6M8ymvGq7W0+oD5LR8e/873JvRFite6nc32E6AGh9s3/tixnmidLBzifdzHNpRg8r8faZM/sf+eYlUtTIUU5/Ky2rscITI4/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=nrJGJs6s; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nrJGJs6s"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260908143334epoutp0390fff0c41c79afdc6272c4e4bcfff64a~TXxOQIAoO2444324443epoutp036
	for <linux-scsi@vger.kernel.org>; Tue,  8 Sep 2026 14:33:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260908143334epoutp0390fff0c41c79afdc6272c4e4bcfff64a~TXxOQIAoO2444324443epoutp036
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1788878014;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=nrJGJs6sqVhOaxEvT8dTQ02jjV/bxFXD7+LimJ0d9wvEdZy0mzGe4yVhe5YSEVFqe
	 F6inyu8w7KV0U14Efc+l/mkEg5sGnGwB0xZyVyrnu8PofxWRe9yw32bBzZim5uvwIP
	 7vO58XI3hCdCea18L4BRhqzSbUhVsfti/pcNQXoA=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260908143333epcas5p37538426ce635fea9cdb24870601d6448~TXxNYqBdB0811008110epcas5p3j;
	Tue,  8 Sep 2026 14:33:33 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.95]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4hfRJF063cz3hhT3; Tue,  8 Sep
	2026 14:33:33 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260908143332epcas5p1a0aeda9d74f18a8ca6037b383e441d63~TXxL7EqSz0873608736epcas5p1-;
	Tue,  8 Sep 2026 14:33:32 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260908143330epsmtip26a1203323db9cd1337b5967c31eff8bb~TXxK370kI1996119961epsmtip2d;
	Tue,  8 Sep 2026 14:33:30 +0000 (GMT)
Message-ID: <f14985ca-3900-4700-a5fd-e6492403e309@samsung.com>
Date: Tue, 8 Sep 2026 20:03:29 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] add a "pi" group
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, John Garry
	<john.g.garry@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-scsi@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260907075822.749818-5-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260908143332epcas5p1a0aeda9d74f18a8ca6037b383e441d63
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260907075858epcas5p4d59f2327f7ef44227c3b8bbe3367c12f
References: <20260907075822.749818-1-hch@lst.de>
	<CGME20260907075858epcas5p4d59f2327f7ef44227c3b8bbe3367c12f@epcas5p4.samsung.com>
	<20260907075822.749818-5-hch@lst.de>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
