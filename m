Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118654A2E24;
	Wed,  2 Sep 2026 14:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788359924; cv=none; b=g5zdLQDWPn7wPPH5goCRn3AhUZYpCa0KFSYvmVxMAEYlRZTDK91KP6dZrbSWyQkpDA4/DokbYCS+ctRtvXt6gV5N1C9rFoYD2EP0gUJzgsE8lhSPAHEMzvMtRYo3dn8pqAyTlJP/vEFbUK8qUcbRPPkYmo7x4R9K83icivMVTRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788359924; c=relaxed/simple;
	bh=RDsUJlK+/YkzY+Va8q99KELtmpRFUN2BWoxoMHaGJ9U=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=QnuPOg0o0xESEylyTRKfx+OriN+7fw7l3RnTvere6l6sXM6G3KiOwgUJeVDvn3a5UTkqOCoAq2GDvs1JHcv+KTb2aafc8vMQJ5zmSfH2YTXHykSpiuk2YhoB7NMvBrB5G7iKIa+bflB+w04KjoU95uQNd2KpTLZLYalyb4++4rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nsO7CQhF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nsO7CQhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739991F000E9;
	Wed,  2 Sep 2026 14:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788359922;
	bh=F2Qj5ssAwsoQVc9Ky5Bzi5ZGDu6J0aL7LPT3x6KMRtk=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=nsO7CQhFmWDLHfEhLPHRdHLju4aE7MAjcJ0gbu6iymlmNrLpfO1f1i3VDZfvhE5UY
	 ReY6+Lq2L8ll0yStG8cu+Y2DEW5Eed1TqEFwXOXNAAk3KH4Wu3lUQvZ+eSKWK2K/sn
	 Htmo9pLFNAeja1O6Sv13zhwRquKx/5vd/iqNRP7nO+r5zxtWfvnTiVNr/5KxYIBihV
	 fq+J3wspALqrzBFJAn50ouUfx61s/nXl65wa+m26bi+nuWTahG0AD+qIzAYs0pe4Vz
	 EzEN4YHQPa8ZlTlReAm9DL2U1zr2JeYc5CiKkB3M6EJ2PP57W3tmE8n+XwJgJpPgGk
	 iSRg87a8fcwMA==
To: John Garry <john.g.garry@oracle.com>
Cc: James.Bottomley@HansenPartnership.com,  mkp@kernel.org,
  linux-scsi@vger.kernel.org,  bvanassche@acm.org,
  linux-s390@vger.kernel.org,  linux-ide@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linuxppc-dev@lists.ozlabs.org,
  linux-usb@vger.kernel.org,  John Garry <john.garry@linux.dev>,  Damien Le
 Moal <dlemoal@kernel.org>,  Hannes Reinecke <hare@kernel.org>
Subject: Re: [PATCH v5] scsi: core: Drop Scsi_Host.default_lock
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260831095821.3486994-1-john.g.garry@oracle.com> (John Garry's
	message of "Mon, 31 Aug 2026 09:58:21 +0000")
Message-ID: <yq1ld9jg1lv.fsf@mail.kernel.org>
References: <20260831095821.3486994-1-john.g.garry@oracle.com>
Date: Wed, 02 Sep 2026 10:38:40 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


John,

> Back in the 2.6.xx days, it was possible to for low-level drivers to
> set the shost lock pointer. That is why there is a default lock and a
> pointer to the shost lock.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
