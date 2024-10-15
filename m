Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96BC18BB84;
	Tue, 15 Oct 2024 21:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729028892; cv=none; b=Y1m/AZ3+m1EFNXNvXjSM9MVHjD1+fNXlkaqSbsY0jXsaNCjU5HFcrq84EJRkeO58dtjaSFz02RClbCBLK8OFe+A6U/2GIXNT7uSBf4XRNKOn48p5IAxViYNNhhnbVzt64A8fnt57Gwqy9uLPdGZ1Evdn5sE8zsRJur4WY8ChpjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729028892; c=relaxed/simple;
	bh=LHtP3qPFkbfoli3ZXTb8e1xlPp4DeRzZwv2eNaX8jDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FfgJn/uQE8y78H7u6Fv+o8xcP0WpUM3JR1yTXNR2IvZTHz7AqJX8bKNEdtaV5PYtAPPm5AH7siAFXh7/jmmf75/de4sFDsrW1jXI7+V9FNTHlugVc+1mi62PhtFdDITNENS9F1TGcTGRtnq+mdBY5dwl/y6jeqdSNPApCNoBUxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=Ne3Tinpu; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="Ne3Tinpu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=T5a05ILCG4Q76Wew1TSwZJHR6DQTGSFk7b9OMwsxIKI=; b=Ne3TinpuXVgPKeOn
	+k5e8Aw242kJAxO9I4S5yhkfrqtKgoa95MP+4HZ6s36Oxoq7gN+zlD0hZX/wRNcbxzwI6IQmYmWt2
	1r8pENTdgjvh4QSUacyIfcccROQBVzTVPIIYfgVymLydQaXJtCLCjf5QUekEXER3eaEZV8vMvoUH5
	E1Up2HHSHCHjuiumqn9a/PUEtAzdNUFLhFjuIk/aXPnD70KefZWVn67V777gbQZBt8NE1gTJzLwd/
	X5N63dBYuZd2P0wesDDmUi7kGGhrsL8sMxLDSGjEWg8wmlDeTZkxZLyJbUfj6eB+LS9Dbu/WuO+ZS
	FTRR1ntAPcEnaoEgJA==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1t0pOe-00BJf3-2Y;
	Tue, 15 Oct 2024 21:48:04 +0000
Date: Tue, 15 Oct 2024 21:48:04 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com,
	James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] scsi: bfa: Remove deadcode
Message-ID: <Zw7jFFSzcSPfln2Y@gallifrey>
References: <20240915125633.25036-1-linux@treblig.org>
 <yq1ttddqdbh.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <yq1ttddqdbh.fsf@ca-mkp.ca.oracle.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 21:47:54 up 160 days,  9:01,  1 user,  load average: 0.07, 0.07,
 0.02
User-Agent: Mutt/2.2.12 (2023-09-09)

* Martin K. Petersen (martin.petersen@oracle.com) wrote:
> 
> >   This removes a pile of dead functions in the SCSI bfa driver.
> > These were spotted by hunting for unused symbols in a unmodular
> > kernel build, and then double checking by grepping for the function
> > name.
> 
> Applied to 6.13/scsi-staging, thanks!

Thanks!

Dave

> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
