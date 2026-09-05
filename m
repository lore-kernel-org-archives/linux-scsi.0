Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E676C334C05;
	Sat,  5 Sep 2026 03:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579074; cv=none; b=NVBI4K4HDRhM9UZUVzF/xLWF4QjlrULh88R44yprkYJIerZ3gtQqLxCSjS9O8k8TyUr9GbLbbAPJhxkP8DJD/62iD4J6uZMg/yg+/R0y61biz/UnShnPEY/rIGbxVliwR3jV5SEHoNNMKLLNqUjab1oQwI8sUSXdsac0G95Uk9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579074; c=relaxed/simple;
	bh=q0rs+DrW1NfqE9gYUxfiSngjnooYSLLSkSFSlZ61Z6Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TN+Pld5K3JGLzOU7z23hdbQMYp3OI/f+d3bZr2DmXArDMAHeeu1AsQqTptPY5OaS7Lgi8j68YQ8vuQZtgZH8qbTvIPHEfrcKcCHC3keKPLXPYWlI+HcsLTuvhGtmp/FnhrAFKQTtFgcM7mcaRt22skSC32PB46U4Jteom/DEe+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aXTK+sLC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aXTK+sLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EF11F00A3D;
	Sat,  5 Sep 2026 03:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579073;
	bh=q0rs+DrW1NfqE9gYUxfiSngjnooYSLLSkSFSlZ61Z6Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aXTK+sLCoavaiPh4UPvKda/ib5hS7SNSa6rtm2mOvDRTSpjWhOyyN+WDJ3y+G7jjv
	 IeZmVbb3BSY0Kr+54KCdlT24am4fGEVqsdzvrxRzq/hajdvAK2EaeLs/aV8XETWdMr
	 hn/yPMmrVaooVFuJzt59QkAVLMpftWT418KWvF19j8TVQ28R90StUPqtgKXJTNWV6q
	 TxLhQvaRK0CgPeDkUldQjG6RTE9INXhDjnQzJPrhbho7Rxi/m7RLGjsIgj5rW3LV/4
	 8OmU3rbSfIXKxk/DK9uoWbR1tnfhXP2yAx4Us5ELYT0bD0rmwwSXJ4gudKgd/mfWQx
	 srQbwIHnCCRlw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 18/40] scsi: mpi3mr: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, linux-scsi@vger.kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-ide@vger.kernel.org
In-Reply-To: <20260905032224.509860-19-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-19-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:31:12 +0000
Message-Id: <20260905033113.05EF11F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the mpi3mr driver to use the 16-bits sense_code field of struct
> scsi_sense_hdr and replace all hard-coded additional sense codes and
> additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D18

