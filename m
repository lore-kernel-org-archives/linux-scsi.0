Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F135128B415;
	Wed, 16 Jul 2025 07:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752651294; cv=none; b=YopaHwRbfJPj1GK+DFCDT42Hv9vwigCunTZS/E+i6HJPEhUjvyqhlFjJ7a5dd4FQFhBzfDfrjn2S5m1ZNoy44mT8lZ0P+wf5LyKHDhOe46plC0OZXD32po13ggvZze3oKX78bPe7WHTJsq2ExcUnh0EDdSdUpJEfs7HXAwEirxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752651294; c=relaxed/simple;
	bh=MAfUcRJhcWy2S/8h4cB47BcOEwwZTmwwIcGrYV/7Nuw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=UelEU9R5D2RlMqIwFLzX9u4oAYGPyl6t9uiUEqQlUn6zaspMRkNvVxbb2erNVYoNkbPOcq1er/MiKZVOqxgrtm9AWxxzNKxSXd9MBk++qje1pMkEYxwoVVTPK19gPa9s8QzCTGQc6eD8XNmQqp4h7LiYDlaOCQ5/Eh+WLgiv+Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XqppcLe3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XqppcLe3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A31C4CEF0;
	Wed, 16 Jul 2025 07:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752651293;
	bh=MAfUcRJhcWy2S/8h4cB47BcOEwwZTmwwIcGrYV/7Nuw=;
	h=From:To:In-Reply-To:References:Subject:Date:From;
	b=XqppcLe3AsE6l2cFhvYmHZP2tPg7fkC2sR09/gUwminE+KtBC6uUDV0VepNMydNLK
	 EpDGiXyVOFiXtEg6RICv+RecuEYGpkadt57gjLI7E5ibuqylQQE6LbiFD99zZU6bl7
	 WoS8Ywb7E/7JZMfVMpHd7R7URlMgq585AMAs0YeleJaRoLZr+ftVqeDMjuGmaVkOAa
	 TVc9kXnu2qYWr5oXCp/WN4ZC3T1B4grwnlLRy2cBuTBPNhwAtRHyj1/vc2H1nTHkbD
	 a4eijY1l9oHYmFCSXL+HOXrDrhRB3N3wufsWXj/dNSO8G+dqWESnDQWyFmRyr2JeVa
	 xxKfBERIDVIrw==
From: Niklas Cassel <cassel@kernel.org>
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
 "Martin K . Petersen" <martin.petersen@oracle.com>, 
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, 
 Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20250716020315.235457-1-dlemoal@kernel.org>
References: <20250716020315.235457-1-dlemoal@kernel.org>
Subject: Re: [PATCH v5 0/3] libata-eh cleanups
Message-Id: <175265129200.2810902.6158120327068101000.b4-ty@kernel.org>
Date: Wed, 16 Jul 2025 09:34:52 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 16 Jul 2025 11:03:12 +0900, Damien Le Moal wrote:
> 3 patches to cleanup libata-eh code and its documentation.
> 
> Changes in patch 2 propagate to libsas.
> 
> No functional changes are introduced.
> 
> Changes from v4:
>  - Added reivew tags
>  - Fixedup patch 2 pata_parport modifications to keep the hardreset
>    operation initialization to NULL
> 
> [...]

Applied to libata/linux.git (for-6.17), thanks!

[1/3] ata: libata-eh: Remove ata_do_eh()
      https://git.kernel.org/libata/linux/c/df6f9a91
[2/3] ata: libata-eh: Simplify reset operation management
      https://git.kernel.org/libata/linux/c/a4daf088
[3/3] Documentation: driver-api: Update libata error handler information
      https://git.kernel.org/libata/linux/c/546527b9

Kind regards,
Niklas

