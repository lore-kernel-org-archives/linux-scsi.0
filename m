Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA401F192E
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 01:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791250755; cv=none; b=HHAeWdjIvrrZumEEOwvURRKqk4f5xs0eVoqe/cLmA6Ggji1/lHBexj4RUr3rtHOiUIanjnMzENj4FavpS6m86IADOO1W4DHQqnE0HX6YhMhwTMjn5PsjiOTJYcF5BlxK8xrSfudvlBJwheICnfekVnzPsH08V4+5baKn+xSkbVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791250755; c=relaxed/simple;
	bh=3puhlfhXFz6QYnlc6ehD6YFDP1M7VSI+riT96oQQ1Bs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=m9KmiH1SUqhadvPOtNBPh2VM7FAzDVohiyIzOKVFK5yONGjVzFt+sB+2q4UPE9JAjcWAKIouibgAMK58ZIADalOYUn5erPl2yPR4GonvjV+mXYvuSfd0dKN4FVhXB/XYxirdVaE/A/ga2L44SPTo+dPDW5GuGbaqIC7kDr8mzaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b1zqnj3e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b1zqnj3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDBE1F000FF;
	Tue,  6 Oct 2026 01:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791250753;
	bh=iFbquo8nBihlg4W199Neu5rC7ng/GKHbIF4tZMjFVJI=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=b1zqnj3eh+JDUPlsaNv+qfT9iQV6Jwpsd/GLIlz4tIccFJNTzZitm/P91Vos5q66R
	 t5KqHT5g3ll6qAfWOb6Lp6qy6y4aMXnRuQYIiLOO84A5k/OTLCih/8FU5FgOSBkuid
	 RoTKXfO9f71xjo3Gt7b9DxmMeX5Xa5R6lDr3xztj3MUm/0iDUC1rcF6lULijQJthWG
	 VCpTab3rSlVAPR7DQEQneCYD9kdihLg35EIsufnn/TN56IRO3dRicD7SfUtanzfTuh
	 n5Ms8LkfpS0SEJEd4fr41LCVEQQzjDH2WHMkPBcb0NxST58IyOTedqypxf1gsYD1D3
	 TUumgMqTbdFxA==
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/7] scsi_debug: Enable lock context analysis
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <2fe7fd58-fda8-45db-830f-3197999a2538@acm.org>
Message-ID: <yq1fqyjk3tm.fsf@mail.kernel.org>
References: <cover.1790723966.git.bvanassche@acm.org>
	<yq1a4oulv5e.fsf@mail.kernel.org>
	<2fe7fd58-fda8-45db-830f-3197999a2538@acm.org>
Date: Mon, 05 Oct 2026 21:39:12 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Bart,

>> There are several conflicts wrt. Niklas' zoned write series. Please
>> rebase, thanks!
>
> Is Niklas' series already available on kernel.org? This is what I see:

Ah, a recent infrastructure change meant my trees did not get pushed.

Thanks for spotting! I'll get this resolved shortly.

-- 
Martin K. Petersen
