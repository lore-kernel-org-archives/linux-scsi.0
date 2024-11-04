Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44BD51D54C0
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 21:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730757250; cv=none; b=YFIuSTTq+q6IgGhv+X877eVDkNOCHX+VSWJ6XATSUnA1ljMvyxvGnYXiqrVUFj28SaiWpX6gYI2Ez4ojweJcczc8OybfQXMFijNRA3uwckwnZebYJmW595dExJr57mKFe/XgwynPgUgXEHaKtBgcYIv3dJIaHra037w69nFAGOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730757250; c=relaxed/simple;
	bh=1mOYgVEyCfwO9ol0OEz/kd26PA9/QH9r7EzubR4CuXc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=RtkUKBWHq24nhoVa37VY+qDLshk4HO5BTPKfGbvst8Km1ayitK4sQwT97P+AI6umRLtSQnINdBG2P1F1iSx2Ew0zjCPOHEQhp3KFaDrBGKSO2Nqyab2pmvocz8B+yOiF7gdgGoCtZN4zIH2dR1e8u1t4mn688ESYT3YrT02KyZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id A691992009E; Mon,  4 Nov 2024 22:54:06 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 9F3A192009B;
	Mon,  4 Nov 2024 21:54:06 +0000 (GMT)
Date: Mon, 4 Nov 2024 21:54:06 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Christoph Hellwig <hch@infradead.org>
cc: Magnus Lindholm <linmag7@gmail.com>, 
    Thomas Bogendoerfer <tbogendoerfer@suse.de>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    linux-scsi@vger.kernel.org
Subject: Re: qla1280 driver for qlogic-1040 on alpha
In-Reply-To: <Zyh6tP-eWlABiBG7@infradead.org>
Message-ID: <alpine.DEB.2.21.2411042152530.9262@angie.orcam.me.uk>
References: <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com> <CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com> <yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com> <alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk>
 <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com> <20241030102549.572751ec@samweis> <CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com> <alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk>
 <CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com> <alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk> <Zyh6tP-eWlABiBG7@infradead.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Sun, 3 Nov 2024, Christoph Hellwig wrote:

> >  Christoph can you please have a look into it?  It seems like something 
> > you ought to be quite familiar with if not for the passage of time.
> 
> Somewhat surprisingly I don't remember that details of a drive by
> cleanup 20 years ago :)

 Oh dear!  It was worth asking anyway.  Thank you!

  Maciej
