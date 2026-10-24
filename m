Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792812307;
	b=DUwyIkHNR/HPt/yTpRystf4JQN17A6VooNNNWKeP/9VpPf9Olc79kmkXnxuMgzxgZPyK
	 Z8F7LTFwrr3PJbIEJHOWayd5Po8dB29nMJMw6u+7o+9qz2nbHhrC8f726Z3t1rKG4lKrJ
	 81ZzTKih8yDXgq1HOf8hbuAwP4PtDF6IAOsDj9KgbBkN8nK1c2k37+XM86TrUR2OLPbQy
	 0ZTl3WH/jeYxIfnCdtTTTeLCWk2J5/6NN1XYdx5TjdJO4XRuPKeatsP2qcTjhzTO5cTLZ
	 +9WZS9E2JPpvBh1jhKKPtQ1DjRO8HpT0qh0aOnHoM3ZhC8Z+Crbg/qRmrqZ7kbr+ihg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792812307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=tW9nyRi9rVTki60prFNf1RRVjR7pt3ohDHMxdl/gvOo=;
	b=ubdgCTguw2te6vQm/GdU+JVZmzww2J9l2LqK8HmSQOQuvIDmkl98zlymkxIHbxR4/1YM
	 bRfiLafYTvnWanYaZkqUf5SWqmZhO2XeLCztTfTERhJDz3WjXTNoA7GWlCC3i49j3nt2z
	 Gxxb+fsjIMDL692Utc3mQZMVUXyezRXDx7uWPEh1EhiTSDizfwAWjM+7j0yb7abZx9VEZ
	 vF4Mm08kI2M8Rb6oOOK/D92GrFGGPaeuWC4rYccTWhyKC5vuGH1FtgfVDVumAsBZOWL8k
	 E2xVwmzyINqr21uf6I7zCy9FfzZq5mKUWBVxR+OTj9RQlCIF043xoVybVDGBZVigbTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jvi90pQF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85718606A32D
	for <linux-scsi@vger.kernel.org>; Sat, 24 Oct 2026 03:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jvi90pQF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A80B1F01828;
	Sat, 24 Oct 2026 03:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792812307;
	bh=tW9nyRi9rVTki60prFNf1RRVjR7pt3ohDHMxdl/gvOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jvi90pQF6sTRrJjYrzt4C/lM7YwkbOUvgPv3i9+CDRL9kmyjbE2P+WSSuC8Mdq25j
	 4INCvXGLxgYJW7Mg4COlfvIfzMO83/DywggMtATtd/nMqTxtKfTHArrFEp9rWPpElX
	 u3ZohfeuEnVYtWYJDgz/KH5DPT1CohfdKznxQR5sQCUqAabq6k3pClKkSA1tDfskgO
	 3BdyOJxMpz0oQ2RzreXxjhyuSpmP77kATIQQLojcexLBUKC4WQ4+pJs3rbX0YM7qmo
	 M9XIivxGY+wo2tn0ewhwiTYX567yatsLZ5FQgi/xNkqgwGKSq4+Z0duWDc0uyLkE9k
	 Ys3kyEf4epQKA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com,
	Nigel Kirkland <nkirkland2304@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	jsmart833426@gmail.com,
	paul.ely@broadcom.com
Subject: Re: [PATCH v6 0/8] lpfc: Update lpfc to revision 15.0.0.1
Date: Fri, 23 Oct 2026 23:24:55 -0400
Message-ID: <179280384856.3823844.8496703350326108914.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013001648.62289-1-nkirkland2304@gmail.com>
References: <20261013001648.62289-1-nkirkland2304@gmail.com>
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

On Mon, 12 Oct 2026 17:16:40 -0700, Nigel Kirkland wrote:

> This patch set contains important bug fixes related to cleanup
> handling in both normal and error paths, and refactoring of
> duplicate code.
> 
> The patches were cut against Martin's 7.4/scsi-queue tree.
> 
> Nigel Kirkland (8):
>   lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid
>   lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not
>     set
>   lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted
>     cmd
>   lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error
>   lpfc: Rework I/O flush ordering when unloading driver
>   lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handler
>   lpfc: Update correct ndlp refcnt when rejecting an unsolicited PLOGI
>   lpfc: Update lpfc version to 15.0.0.1
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/8] lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid
      https://git.kernel.org/mkp/scsi/c/aef36d2e16f4
[2/8] lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not set
      https://git.kernel.org/mkp/scsi/c/86866706d0a9
[3/8] lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted cmd
      https://git.kernel.org/mkp/scsi/c/e7e065ec672a
[4/8] lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error
      https://git.kernel.org/mkp/scsi/c/57b0a51937ef
[5/8] lpfc: Rework I/O flush ordering when unloading driver
      https://git.kernel.org/mkp/scsi/c/5750b941ac75
[6/8] lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handler
      https://git.kernel.org/mkp/scsi/c/75ae9d50b843
[7/8] lpfc: Update correct ndlp refcnt when rejecting an unsolicited PLOGI
      https://git.kernel.org/mkp/scsi/c/8dbdaf88f4b9
[8/8] lpfc: Update lpfc version to 15.0.0.1
      https://git.kernel.org/mkp/scsi/c/3aeac6a2c2ef

-- 
Martin K. Petersen
