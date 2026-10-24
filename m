Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792809978;
	b=D1MUMm/XmC9HhKcEGNDdwFJ+wFbo8Nmq9JqsORN4evh6KHYooE6zZ6gqC4W8W9y5BWAD
	 kjj5LVFr8hU+N5KuXwfDS80V+Yh3P4icmCpcld/7DjvxGjkTJy8njl18FhYytpHmXiojL
	 AsuJ1hx1rKnljr5vo4xSx943d4rwhGuxXUwGV5nEgSNLW1DjaHYwMI9PlKA8B+yILsnTx
	 C+PI+HsgsBcrOyQCys4HtxaxfP830SFFbvzY96z9bd4HgJEWM0v08PkIGz+sayOYYzoJx
	 QFNy1zAko9LUAgf6sT/eZ3CuvG7cbfytVhc+55B79cHjp7LKRnj+QVaUURvoHJ8N0eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792809978;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=pT6zx2apOrfdpBzUBKN8oRSaDsRZsmJ1DYkHGX8CN2Y=;
	b=g9yucbLrNPA8C3RsO9eP1hofLxQSNakBy9u1e7oyuNnf3ZNQ307dRbiwiwVVB9NV5Osm
	 cRWJlSBsjei7jTNCg8OGfu9xomGwX0jx6TgXui67FBUYR08mh+sd4xY+UBLprhFSn3k/g
	 62gKRBcOFp61DCDa8PFRWt8DMpqR8VHwQSszsT8RpFghFliH8WxhJYvNH3piOBH29eTRI
	 ZhbyCo3i9Jb6av8A4fK0OJltQpzayYuS2Og2Gn3dxLI2tPXw4Jz06hxlXfU1h05DRKz2X
	 SiN6hwsLwyMMCHBGB6eFB/WRXFJSTPhTjdleB+hBN5nLdTk+aVCzNLw601rn8ETuPVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bwR1cgaN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048AF606A31D
	for <linux-scsi@vger.kernel.org>; Sat, 24 Oct 2026 02:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bwR1cgaN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4CA1F01825;
	Sat, 24 Oct 2026 02:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792809977;
	bh=pT6zx2apOrfdpBzUBKN8oRSaDsRZsmJ1DYkHGX8CN2Y=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=bwR1cgaNDW1aKGeDu7qtNC8ruHwFjYr24GjVweLbUUqX7haRWoldQeB//2Hb+9NcH
	 iEWOlSaCHHE52H7hwewFn0/le4cvyC1gIRypsB9K2o6ElclsaVGR/IxltfyjPu2jzT
	 hNOnFGV4XdIMK21ZU4TpdIh5GlxoQla81RyCGSnS16ybNOF3mxsK3tZPYsEPnv78n8
	 Y5LsGawf9SQIriTdPzchlCfhl3nsS9ExSgEwZR9N+m4GQ7e5Qxho75AwgNQtz4okgC
	 AGKawaSq7Qr+4LsoHlqG0zZNps1XH30qgtAPRKPdveqn3TM80y5pL+nRMIt7lKG3zj
	 00mBhQ3Tnl8dA==
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
  "Martin K . Petersen" <martin.petersen@oracle.com>,  Bart Van Assche
 <bvanassche@acm.org>,  <linux-scsi@vger.kernel.org>,  Bean Huo
 <beanhuo@micron.com>
Subject: Re: [PATCH v3] scsi: ufs: core: Fix stale comment in
 ufshcd_mcq_config_nr_queues()
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <1792370062-23050-1-git-send-email-shawn.lin@rock-chips.com>
Message-ID: <yq1v76r95ow.fsf@mail.kernel.org>
References: <1792370062-23050-1-git-send-email-shawn.lin@rock-chips.com>
Date: Fri, 23 Oct 2026 22:46:16 -0400
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Shawn,

> The comment refers to "hba->dev_cmd_queue", but struct ufs_hba no
> longer has such a member (it was removed when the dedicated hwq for
> device commands was dropped). Reword it to describe the actual
> requirement: the queue is a host controller capability and it serves
> both non-polled SCSI commands and UFS device management commands.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
