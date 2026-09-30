Received: from outbound.easymail.ca (outbound.easymail.ca [64.68.200.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8B044AB7A
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 20:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.68.200.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790799241; cv=none; b=lOkuyR+24RATSiWY6oUTqgIi1UL3SI4nmkaKdneJeh1OE54E50DjUsMXU7B6PCXZDgtL7lsairrfTOKEjLSyxVP76xTWcD4cf8J440g9BihHJAMxXyeg9Sb8nKEywxXyXrlhhkFJXoV4SPDqTqGzyO7bkNXsFrlBAyNDAfZMNjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790799241; c=relaxed/simple;
	bh=BhMHyF2Hde+NwNmeiDyr9h8FCetdYbM1lBjMmaqMRos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=brg2OfAmXJTMQMw1ZhvuIArfiVRgHOtu+HJoBPCmxfdR0eeX60ndP6fgdoe9m4yd9PR7Ixn05f7T/OuvphaZ0W+b+Jf3CQvmv7C4MInp+tu2uyX8kWnLnO/65KS1ZuVJGQXZsf4fl13Jnay4J/rhzMdW1aPwFif5cU7YfLxOtts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gonehiking.org; spf=pass smtp.mailfrom=gonehiking.org; dkim=pass (2048-bit key) header.d=gonehiking.org header.i=@gonehiking.org header.b=WU1sbPU8; dkim=pass (2048-bit key) header.d=gonehiking.org header.i=@gonehiking.org header.b=WU1sbPU8; arc=none smtp.client-ip=64.68.200.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gonehiking.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gonehiking.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gonehiking.org header.i=@gonehiking.org header.b="WU1sbPU8";
	dkim=pass (2048-bit key) header.d=gonehiking.org header.i=@gonehiking.org header.b="WU1sbPU8"
Received: from mailout.easymail.ca (pco.easydns.net [64.68.203.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by outbound.easymail.ca (Postfix) with ESMTPS id E767C20C8A;
	Wed, 30 Sep 2026 20:13:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mailout.easymail.ca (Postfix) with ESMTP id D332061276;
	Wed, 30 Sep 2026 20:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gonehiking.org;
	s=easymail; t=1790799232;
	bh=7j+rzxFZG+hckjS6RqHiZLjGAy+VU6nfZXDoNAN+B0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WU1sbPU8mJDpZVqN2CObWAhAqGR1KNI/n1MIfml/qAabvkhFxUtoYyUShaDbiSZKu
	 6a0RuPxV1bn5+4PxeRdrCpfqm64ouBoqMQhD+/anGKsTE7bGIqusy3vzI6b3DHbq9m
	 5r2OucidT6Q0Q1cBr5oUcme3dLfFtofzlMY3yUYhrtjAoMnJnC4NLkFnmrRYzM8qcy
	 JVDTn0x45OxHnkT0FiBGSvWJ9kO8ycqAV3kFdgmsgPv498mnSlylnsolmmfwO69Mzz
	 MpkWubPWhE58PUua6lBDol4of2aPiqntfirov0qycH/ff5LWfQna+q8XeArtDfLZF5
	 wqirO1ovylUyw==
X-Virus-Scanned: Debian amavisd-new at emo09-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
	by localhost (emo09-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hKZ1IzoRbX6n; Wed, 30 Sep 2026 20:13:52 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by mailout.easymail.ca (Postfix) with ESMTPSA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gonehiking.org;
	s=easymail; t=1790799232;
	bh=7j+rzxFZG+hckjS6RqHiZLjGAy+VU6nfZXDoNAN+B0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WU1sbPU8mJDpZVqN2CObWAhAqGR1KNI/n1MIfml/qAabvkhFxUtoYyUShaDbiSZKu
	 6a0RuPxV1bn5+4PxeRdrCpfqm64ouBoqMQhD+/anGKsTE7bGIqusy3vzI6b3DHbq9m
	 5r2OucidT6Q0Q1cBr5oUcme3dLfFtofzlMY3yUYhrtjAoMnJnC4NLkFnmrRYzM8qcy
	 JVDTn0x45OxHnkT0FiBGSvWJ9kO8ycqAV3kFdgmsgPv498mnSlylnsolmmfwO69Mzz
	 MpkWubPWhE58PUua6lBDol4of2aPiqntfirov0qycH/ff5LWfQna+q8XeArtDfLZF5
	 wqirO1ovylUyw==
Received: from [127.0.0.1] (localhost [127.0.0.1]) by mailout.easymail.ca (Postfix) with ESMTPSA
Received: by rhapsody (Postfix, from userid 1000)
	id DBE8B1E5AEE; Wed, 30 Sep 2026 14:13:50 -0600 (MDT)
Date: Wed, 30 Sep 2026 14:13:50 -0600
From: Khalid Aziz <khalid@gonehiking.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: Re: [PATCH v4 04/54] scsi: BusLogic: Pass the host pointer directly
 to several functions
Message-ID: <ar1tfqjrKkyTxUid@gonehiking.org>
References: <cover.1790360262.git.bvanassche@acm.org>
 <09e99ec9c6fa24ee5fe3c47110c88a1be076e01a.1790360262.git.bvanassche@acm.org>
 <argk3DLMl_YSDOsV@gonehiking.org>
 <97ab2119-2067-4c6c-9edf-286666f94e40@acm.org>
 <arq4GHK0OLyusPBh@gonehiking.org>
 <f0c2d0ab-659c-42c4-a8cb-4978dddc29e5@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0c2d0ab-659c-42c4-a8cb-4978dddc29e5@acm.org>

On Mon, Sep 28, 2026 at 12:28:57PM -0700, Bart Van Assche wrote:
> On 9/28/26 11:55 AM, Khalid Aziz wrote:
> > I prefer not to pull in macro definitions from header files into the
> > driver code. This opens up possibility for API inconsistencies if
> > the macro in header file is ever updated.
> The DEF_SCSI_QCMD() macro was introduced in 2010 and there have not
> been any changes to its functionality in the 16 years that passed since
> its introduction. Hence, I think it's unlikely that it will be changed
> in the future.
> 
> > Why not extract struct *scsi_host in blogic_qcmd_lck() from
> > struct *scsi_cmd instead and continue to use DEF_SCSI_QCMD()?
> 
> Because it is the only way to avoid __assume_ctx_lock() in
> blogic_qcmd_lck(). __assume_ctx_lock() should be avoided if
> possible because it defeats the purpose of compile-time thread-safety
> analysis.
> 
> The BusLogic driver is one of the few drivers that releases and
> reacquires shost->host_lock() from inside blogic_qcmd_lck(). Preventing
> that the Clang compiler complains about the spin_unlock_irq() and
> spin_lock_irq() calls in blogic_qcmd_lck() requires adding a
> __must_hold(&shost->host_lock) annotation to the blogic_qcmd_lck()
> function. And adding the __must_hold(&shost->host_lock) annotation
> to the blogic_qcmd_lck() function is only possible if 'shost' is one of
> the arguments of the blogic_qcmd_lck() function.

That is significant code change just to satisfy a code analysis tool. That
is making me uncomfortble to say the least. Even if DEF_SCSI_QCMD() has
not changed in 16 years, I am strongly in favor of using standard function
definitions especially when offered through a common macro for the subsystem
and in my opinion it also enforces the soft agreement on API between SCSI layers.

I am currently traveling without my laptop and it is hard for me to do proper
code review. I will get back to this in about 2 weeks.

Thanks,
Khalid
