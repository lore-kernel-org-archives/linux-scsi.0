Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150CA253B4C;
	Fri,  7 Nov 2025 12:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762519140; cv=none; b=dDOHK6aTh18ZloAAQo/SvJxoMIMCX39elYKjyczYsg81xAe3HWRrNZQrd1rdwpVyUrI9RgHA7uiyBk9mVorRkgG+xUP9O/XKbZdhP517sqd3mQYsVOXdVfzad9D3Q166bvIwDmTS/UDsRgR51vjVub8U4stHOKogC4Rz5BuCwfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762519140; c=relaxed/simple;
	bh=LYQVTmkpgyHJU99oHJyisesvpOjMTFtT39nRQnS2hJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tQyKOEfyvRHld4OTjZLHsbuOzSe+7WAJty5PgHqAdkDJrg5nzM/vITMZc0HgfRXx1f6rnAcR4f2NbC9b22BE5f6IYG9VKVWDegKF+FHQw8Ynr8UNnPOy584le9PA6fJIlMvf6Qk9dcbcnEjP6Pvj7+rKft58PHkiZvWn+ueWREc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=ybgPoOga; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="ybgPoOga"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=XtSkddwD/WDmFGCg39eRmShA6VwhT8kIPIGtzp3ms2Y=; b=ybgPoOga61pdrRlKUv7LHd1QNE
	JH3d8zQ8ENjCCEKgv03vWO+HTMT1Bi+0T70rXtdkBQA/bcvx1CqOGA/HEI1WHmSkS+CZHxLY7AS0L
	nl/Nqt+Hjj+qz/KGhJhbGeDQhA31vJnWuVW6sBIC8mpOrkxURH3UPUXD7FJElKdSU+NCrSheEsVhy
	Vk0DAh9qd0CpSng84SvkaV715UlH1TM/3WmEHEh/TK1xE995eXi655tByWsCVZNnseJrGP6Z9NDC9
	LdLgMXzHXxqI2RcqQnYcH0f0HEsmI8TpWm7fzhERAm6l5dKHfzsugHH3rKLEnnIEH6vzHbcQ2TyKV
	PbCSnyuw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41666)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1vHLju-000000006XW-4Be1;
	Fri, 07 Nov 2025 12:38:51 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1vHLjs-000000007aG-4B0v;
	Fri, 07 Nov 2025 12:38:49 +0000
Date: Fri, 7 Nov 2025 12:38:48 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Darshan Rathod <darshanrathod475@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi/arm: Clean up coding style violations
Message-ID: <aQ3oWITFc3F6Hwhu@shell.armlinux.org.uk>
References: <20251107123435.1434-1-darshanrathod475@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107123435.1434-1-darshanrathod475@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Fri, Nov 07, 2025 at 12:34:34PM +0000, Darshan Rathod wrote:
> Addressed checkpatch warnings by separating assignment from a conditional
> statement and documenting the empty for loop. These updates improve code
> clarity and maintain style consistency.
> 
> No functional change intended.
> 
> Signed-off-by: Darshan Rathod <darshanrathod475@gmail.com>

Up to the SCSI maintainers, but this code pre-dates many of the coding
style updates, and I believe there is a general policy not to "fix"
old code for such things. It creates noise and additional churn.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
