Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767822E8B64;
	Wed, 14 Oct 2026 03:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791949756; cv=none; b=OT8ypOE4JWYg703uZrq6pFL6x7tlTkj/iRMLXk/H5rQqV4mWMgwM/3QOOfEe9tv7qQvfud4kUo717gO/oEXHf2Ej5AOOZGa/XzOQsR4ALhUWlFckACgduxQ6x8Lw/U0W1v4oHUa2BAuDG9K4cAOMsf+2CVcGEeI2qMfS3Zl3uSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791949756; c=relaxed/simple;
	bh=gzm1MYBnjiHbw/nylqbKHcZiq9QhiOhAMCEvfoGp9Zw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=d9vR2txLwF//GHlsK9s+vfFjFcY//Kn5dtsLijB4q02bUaNGXgXovtmV4Iw8Lc0XIbDG7stOOehx/ynLEXcJSNMdmig47pv8/xkWjS3nloyCFtgPsPvHpka3oGV7Ww6GLmF0uN9Df7T6hKLF/hhGfTAqyU33T86CJUIUCRmu1mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fcaNDndA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fcaNDndA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B551F000FF;
	Wed, 14 Oct 2026 03:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791949754;
	bh=pjwDiI8ilvIe59XFRDzaVZx+IGVqLkUhkfQadIkhnfE=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=fcaNDndAZIGh4iqXCgtykXIe4i75UXur/cjos8vNx8MfM/gOhC8Iz5nzgDtcxNGsj
	 tKQEdduR4HywcLHQSMzMMdzzX61ahuQEixS191BTgL5iK5evMy6Jn042vPZBTyDrmg
	 AINcc87UUfHrFGuFZl/oo5D1M9AeTu/I7ZvKEw5KlvXweZ1nweBX5j2o3DP1hz4aoS
	 5gc+wp3oeE7MlFBZD7CbpIfg2O1Xe8REYiZCNxessZhOlu6SbVFor/wT5pndvXKLe+
	 EfX5R32i3kp8nu3+CJ0FwmC4/S35P+mxDZalWZ0JUf+/v9iTIt6UQ4cQi5S0VmRH+s
	 Xuqs5EKNRBq4A==
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,  linux-block@vger.kernel.org,  Christoph
 Hellwig <hch@lst.de>,  linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 00/10] Add support for storage element depopulation
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261013122750.2237843-1-dlemoal@kernel.org>
Message-ID: <yq133u9eydh.fsf@mail.kernel.org>
References: <20261013122750.2237843-1-dlemoal@kernel.org>
Date: Tue, 13 Oct 2026 23:49:13 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Damien,

> These patches define a new set of block device operations for
> generically using from the block layer the storage element
> depopulation feature of zoned block devices. Support for this feature
> is added to the SCSI disk driver and an emulation of this feature
> added to the zloop driver.
>
> The management operations can be accessed using block layer API, which
> is intended for file systems (e.g. zonefs and XFS), as well as using
> ioctls for users using zoned disks directly from user space.

Looks OK to me.

Reviewed-by: Martin K. Petersen <mkp@kernel.org>

-- 
Martin K. Petersen
