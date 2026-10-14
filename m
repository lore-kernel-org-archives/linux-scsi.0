Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34561368D5E
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 03:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791949357; cv=none; b=a8ruAq02RrKQEs0R91JAWVdNk0erlLJtmWRP//qtP04iyXCrjXtUZfwLKgO7REK8RBO8mlWStKm03AIKeHib/JV4EQI3GOma68xpDHlR04sSIaFpQnoIyuuAj858c6QXO1gQMRCPko/S9eAtVQjLVndUCP5zUBSM4vMA/QQbgz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791949357; c=relaxed/simple;
	bh=Vl4OBJrcZM84Amzf65PiKs516KHCYUs3S2TBDB73vIk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=lsAxjU1y9PNU1MlbtCLXoeHcnNvMlcBt6Qcjykd4sy0Yajln9f945TODznuZr7y8tdmxAQqCjd++LkfEFmSdPAxMf3bY1Ko3YTlVkYmNDQXxYz8bxSOsoWSXICcWHp5umVLdfeoJAWcovntX5jAXOaOb/ILvYB1tnVu5qFnDxKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gC6/RHpM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gC6/RHpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726971F000FF;
	Wed, 14 Oct 2026 03:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791949355;
	bh=zftee+SqAVNduILBbtBsBQhZhQdWc0moRW+pbzyMBq4=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=gC6/RHpMR+MAjYHoP4X8FFC0JegCUJnyMIJa8O425CIXyYbMgit2lpIIpd/uWY7Vp
	 V8wPa771pOnJiwHYSiRFTV8wdilwJ+xtcVnn8iSTXOx5GbULV4q6xiTAnS6S9HmOwj
	 BU450LVyVncgQk2a0/35Ebw+2WgVeh0lS7SAlEidbO/iKRJjCb6ugudoIcEqEVI/AO
	 YfiNDUGyZevrGGjnsAeDWoWyYW3qzITx0jkYMAPsJnScfiS6mS73h7v4mqeyDk6/hM
	 6iy4cWI3h+EyladZoRgt1FFpOA6YI0TXm51xPnofTKXDc/suTvW9Zch2iSDlVMPor5
	 YELkCDtFhfQ+w==
To: Nigel Kirkland <nkirkland2304@gmail.com>
Cc: linux-scsi@vger.kernel.org,  nigel.kirkland@broadcom.com,
  jsmart833426@gmail.com,  paul.ely@broadcom.com
Subject: Re: [PATCH v6 0/8] lpfc: Update lpfc to revision 15.0.0.1
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261013001648.62289-1-nkirkland2304@gmail.com>
Message-ID: <yq18q41eypk.fsf@mail.kernel.org>
References: <20261013001648.62289-1-nkirkland2304@gmail.com>
Date: Tue, 13 Oct 2026 23:42:34 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Nigel,

> This patch set contains important bug fixes related to cleanup
> handling in both normal and error paths, and refactoring of
> duplicate code.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
