Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4C127CCF0;
	Mon,  1 Dec 2025 22:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.164
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764628952; cv=pass; b=hiRyMUBa8BQl6p0zwKxE50p0yaCtS334c1gMYOIotBtRz6wDhmgFkJING75wAqBsdW+SbgAwcGu1KKZXzw848jrmWjZSlNV02D+uDWxXK6xDTI2UtqZTnjoWzg63biotXYNr3XwDjJ+/9Mn64df+hT73uZrG5wnD0SfQ/7XnSoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764628952; c=relaxed/simple;
	bh=8Qh6fIVItww7C4grUXyX00lvA3AI1D78wAuOL+asyZg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TodsPTVwYfEDQvZ4po4hjop3tLKm6twGUH+KeBW/F76/8JLaOkcHrckTenbnXiXjV1mCT73qzBHTCBVrY9v9+pkGHyprNQS5B8Ws79Aq5q/7OjvzfXJyjdLaIyC0H4swTsE+6KL+kMXTOQZG0JTgbYrmTtITG9vjbE+fyBpwWVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=I16C/0vd; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=7qT0dcM4; arc=pass smtp.client-ip=81.169.146.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="I16C/0vd";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="7qT0dcM4"
ARC-Seal: i=1; a=rsa-sha256; t=1764628935; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=kPDBp8e1IgU4xes332zJ/Inhj4585xcu7XigZulrW8ZIx/hXNgTOKOaAv0o28d4gOE
    5xLd5hR6zAyJSQWKjk6ax9HPImY2txG8wngKKKf8GeYDBLSays2ThBdwi55UV2FGJ46A
    uEcjd/sv5S1IJKsWqAq1silfEiMRHsJPV6hdfI+Tfytkpt//kU94EZw3TeS0XQNPKyaD
    N5OJhDrVUsWr65vtd/yu1+Z81jpuRHtBxaN43bGuusMyVRKkY+HobRWXYDsGHYJ3XzEB
    qXYOaw5dTWgsO5HXHlqG/LLxZUnW9zWdxtIISSBzcVERh3LGeB3d+Ow+wa/XgxV3ClGu
    EegA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1764628935;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=8Qh6fIVItww7C4grUXyX00lvA3AI1D78wAuOL+asyZg=;
    b=dtQbpY/iYJVdT/ErH3e0cVKTWdrH2LqtO+l3+GiYANatGl79xvVLXqxW72266DE+4p
    BLI+HVGdRiLerf2T4ZAPhYjCGHK6wxZOOKiptQeL/nk8Q2hv/45b/Y7I4WQyNaTylbBy
    ef+7uxJUh+y5nW59cWpMitTLIJMrnJtn9Gr1xW7SSdzHaiByz0SahAQrl3IXZAMjnK03
    QRp6Ow/IpcFhXh/LDiUtwbMYZpKB8Vdo3wi62uwk4O3970o7WFLCoBRa8tOt5sNInEUe
    uFSW2YhzO1Q2I3MEauQ/vCzHuckJNdM2zH5pqfHfb74pzremmEcte6irH7MATB5BPv61
    ONFg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1764628935;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=8Qh6fIVItww7C4grUXyX00lvA3AI1D78wAuOL+asyZg=;
    b=I16C/0vdjHYcPLGFpoap+wU2xE8XAfqm8vAP1r+ehbmogWKsCLQSQ6g8BWXB4Oq10b
    In6Ht4ftNeyPfvx3ZyO5rv9MvU3jv+0W8EOyN8cQolZl1kiHEftTQQSK/r20luL7CwJA
    KmEjzUpNnmZCXJ/ycEy6V1Rk8EYxarA6yeS5v0wo/E03kNDXQyTbIBaCj+5cuOrTPCmn
    RmcNcF1i5XbrD2wSFVz7qlG13QcXq+81B0RcqC8j9JVxwCuL9b44d5zJ86vNTUf47hZL
    bUy/LkiTuMBwyLZDgi8PMlxNbyGUDkO6K19jnI3d2/HgpjQudQxLOC58dW3nx5ibQbFB
    JnRg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1764628935;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=8Qh6fIVItww7C4grUXyX00lvA3AI1D78wAuOL+asyZg=;
    b=7qT0dcM4ZKv53MwrAKGdmWsioQTACfiJ6Zj9zFIwlfLjBRvVPjkyLOiLNqzigjYwpW
    R5DuoEmv+Ygpj6Xh3MDg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGfEpI+2Qvt16WS6JzbzZhDeE5BIYV70aPpWR5w="
Received: from p200300c5873d61ae7981f81429a76ace.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 54.0.0 AUTH)
    with ESMTPSA id zd76761B1MgEDAX
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 1 Dec 2025 23:42:14 +0100 (CET)
Message-ID: <251eb7e20d91ae9c539bde847ea102a53af82b94.camel@iokpp.de>
Subject: Re: [PATCH] scsi: ufs: core: Fix link error when CONFIG_RPMB=m
From: Bean Huo <beanhuo@iokpp.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: avri.altman@sandisk.com, bvanassche@acm.org, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com, can.guo@oss.qualcomm.com, beanhuo@micron.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel test robot
	 <lkp@intel.com>
Date: Mon, 01 Dec 2025 23:42:14 +0100
In-Reply-To: <yq1seduunc2.fsf@ca-mkp.ca.oracle.com>
References: <20251130151508.3076994-1-beanhuo@iokpp.de>
	 <yq1seduunc2.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-12-01 at 12:25 -0500, Martin K. Petersen wrote:
>=20
> Hi Bean!
>=20
> > When CONFIG_SCSI_UFSHCD=3Dy and CONFIG_RPMB=3Dm, the kernel fails to li=
nk
> > with undefined references to ufs_rpmb_probe() and ufs_rpmb_remove():
> >=20
> > =C2=A0 ld: drivers/ufs/core/ufshcd.c:8950: undefined reference to
> > `ufs_rpmb_probe'
> > =C2=A0 ld: drivers/ufs/core/ufshcd.c:10505: undefined reference to
> > `ufs_rpmb_remove'
> >=20
> > The issue occurs because IS_ENABLED(CONFIG_RPMB) evaluates to true
> > when CONFIG_RPMB=3Dm, causing the header to declare the real function
> > prototypes.
>=20
> This now breaks the modular build for me.
>=20

Hi Martin,

I tested both IS_BUILTIN and IS_REACHABLE for the RPMB dependencies both wo=
rk
correctly in my configuration.

IS_REACHABLE would provide more flexibility for module configurations, but =
in
practice, I don't have experience with UFS being used as a module.

Would you prefer IS_REACHABLE for theoretical flexibility, or is IS_BUILTIN
acceptable given the typical UFS built-in configuration?

Kind regards,
Bean

