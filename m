Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC835371CE3
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 03:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791950231; cv=none; b=HEte55JYjdrMHiQ/kf/zf5Rtgcuhwr8qxAppK4B3vnp8RvCeJSjMfrg3v1VDhfhRCp9K5Z2RyogtxMuWrC27PiXgWoOOrvzLA2YL4vdOpUGAouu2Df31gEhXKLP/imyaXRFNl8AEnEp4IPslIRqtgr/keJEpRo30PTJuU4yp86I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791950231; c=relaxed/simple;
	bh=Vj4puABKFK/680nMNGHP2eGggduzThgROasFWzPooGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LGmZhoy2AHY2CMcQ0q77CvsfOKVSyy6NmaWFpV70HbF3/vq9xDlelf9OgKAsEoT4tmIwrUG2Ej/T29/QifyR/nExAJ6j+jUFY+vw1xVUmptZLeQlidqa+VdYaoOIPRcVWah2fgiOnMPTcrlO2YQT8+pvpPxvve9iHrTKA2U8Ng4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ASOh/V84; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ASOh/V84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DDC1F000FF;
	Wed, 14 Oct 2026 03:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791950230;
	bh=ObbVgna5aPWvPDde01DS3igJ7LHAv9j6bCu8IIf+QCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ASOh/V84g7EAaW4blufXpBoTVCxMVzZkwhYtRYh93/dQW13LB3KZUUtso9Mez/1kJ
	 4M/oHgBr3UtlAOf21jftVCKPAoul40be/oLma4mR/m6n5uO2qOqkM13a6w08tW1tsA
	 GSHiPCRbtreqVWqIjQHjhqexZNH0wTP84VJP5jO+tDXTrac8C38CY3obqvz3gIfVpU
	 8KJu9W3FEnY9HwM1yv2SRYEWLTm9kMotspTIXYJ2I1WD64Bw0FO6G4S7ytcB6/KJO0
	 0Sr8eUEdjMATVtTycMuD1hsF9W+yocN4YxNxOXJh1M5m2i6Y7rjBApiGsSNeNmbxLA
	 u1BIHZVsAHsVA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Hannes Reinecke <hare@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] scsi: core: Fix scsi_done() documentation
Date: Tue, 13 Oct 2026 23:56:45 -0400
Message-ID: <179159633698.2229379.3968138477252474683.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <9d10e1068d75c1a708b3a56e85782d651411fe06.1790359673.git.bvanassche@acm.org>
References: <9d10e1068d75c1a708b3a56e85782d651411fe06.1790359673.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 25 Sep 2026 11:08:59 -0700, Bart Van Assche wrote:

> Commit 11b68e36b167 ("scsi: core: Call scsi_done directly") changed
> scsi_done from a function pointer member into a regular function.
> 
> Replace all references to the scsi_done function pointer member
> with references to the scsi_done() function.
> 
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: core: Fix scsi_done() documentation
      https://git.kernel.org/mkp/scsi/c/931a0649b9a8

-- 
Martin K. Petersen
