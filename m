Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792812310;
	b=zByaemZcfOIUBXukdiBRv+/kUUyAdA3rRoBw6w8TDO9PHKk5B6mq+fWs4Ob59gpa2Gki
	 4bJh0RAWni4TNdUhGstMRiu0NnS/UBgdfuFEQU7PJKnyY3HZj8g4fWtgffuxwvORK4ZND
	 o01OGqaIEc7bUSGxTuZUXjKZ44Vf3JcGrvv4Uv5wKmWYdObLiGcwwO19sbRtCPVk5syOW
	 pEVOr2i3W4aTy2V8RqGG7gFu8N3BrBIQSTyqCxZ4mGcq4DcAOBywCfliHJrb+nr75mZRt
	 jbzqGfdcq/qV+s8HD01AsIcLdVXONTntICHB85TLANRGG4IC+fr14PQHZFEjqEB7aNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792812310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=+Vv0G9U4xBM7Xo92WDByxZ/8b4XqaGzaN7j2K6DDzBs=;
	b=3EfBLtZungLijoMTVuGXdvPvxBsPfjniS274QL+cf3enlYMTNlRZdEes+u/nWrl0ec8Q
	 6uGwf2Xey/ZCjXkpn6rJ654SVZMcIFx2ew0Liu5+EjoqJmotk7hicoge5MGd+L6YafyKI
	 K7+gGxdMDMTZLcLZ6S9tBNI+npISQkgLJ9cSA8dY/d1IvvhIl+OzuBP3h4fHByejniZKj
	 abbdZhTH01mjckNK7gSNKm8xPmxlMd3dBJJrQTWllwP05XrCg8mz3s1n9Ufv1JRwOAy89
	 3CMFA0Toi5CzcEN/xGmBOUNjjI0kg1Rp0Qzp3YSVwzUaSU8KXpAxZlZ6i+66bBVUmUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mONT8OTf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30453606A320;
	Sat, 24 Oct 2026 03:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mONT8OTf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031FC1F01829;
	Sat, 24 Oct 2026 03:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792812310;
	bh=+Vv0G9U4xBM7Xo92WDByxZ/8b4XqaGzaN7j2K6DDzBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mONT8OTfcmMB3LNUInMc3mCDSn5mkwIRC0WGHR9nDPOhqaiobhT8dctzZSIFXMNH4
	 ASDzcBFlIx0C0nXK5nrvMsPhc7KyJ+W+zoPCUZSyDpYlFaOBmtk2zK6uqdwRr5IvmA
	 bmQ4oQfJ5EYUUPKbinUduiR8jKKoRAADIOMlcBuVXBNNyPc4nJON/zSkcU5vZpKYh/
	 uleaQvzS4fRmHgoV9FdxoiS2cli7DrXgjdu3hozIBci3SWgBNlQVsIDI9A0GvRIvtL
	 DvrHi0jvxLAHDiQpO4x2Jc4k2xgOyLJPjyXsctxYxHwqRdPXunpHFVr08LLlO12eZN
	 aYc7j8maiP45w==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: jejb@linux.ibm.com,
	john.garry@linux.dev,
	yanaijie@huawei.com,
	Xingui Yang <yangxingui@huawei.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linuxarm@huawei.com,
	liuyonglong@huawei.com,
	kangfenglong@huawei.com
Subject: Re: [PATCH v3 0/4] scsi: hisi_sas: Some misc fixes
Date: Fri, 23 Oct 2026 23:24:57 -0400
Message-ID: <179280384862.3823844.8851353706623051221.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261009033238.1076098-1-yangxingui@huawei.com>
References: <20261009033238.1076098-1-yangxingui@huawei.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 09 Oct 2026 11:32:34 +0800, Xingui Yang wrote:

> This series contains three independent fixes for the hisi_sas driver,
> plus a libsas fix found during review.
> 
> Patch 1 fixes an out-of-bounds memcpy in sas_ssp_task_response(): a
> device-provided sense_data_len >= 0x80000000 turns negative in the
> min_t(int, ...) clamp and becomes a huge memcpy length.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/4] scsi: libsas: Fix out-of-bounds memcpy in sas_ssp_task_response()
      https://git.kernel.org/mkp/scsi/c/4d7f9c3fdce7
[2/4] scsi: hisi_sas: Fix incorrect delay values from magic-number cleanup
      https://git.kernel.org/mkp/scsi/c/7307109c92f7
[3/4] scsi: hisi_sas: Clear PHY error counts on phyup
      https://git.kernel.org/mkp/scsi/c/7991f33110d2
[4/4] scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_Wait state
      https://git.kernel.org/mkp/scsi/c/92821c2358c7

-- 
Martin K. Petersen
