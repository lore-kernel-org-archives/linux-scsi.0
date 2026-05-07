Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3403C0636
	for <linux-scsi@vger.kernel.org>; Thu,  7 May 2026 10:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778149663; cv=none; b=qlzgdE/zcVwgmphtZcR9VyzOLoYyp449kvwM7KjQUT2rv6fjQPfVKO0PKncxcMx40yvhMU6G/9EK74JZgc+jpv3OdWW8shNuq6A6upbWIcwkpZK0Ny3GHnNzJ0uPuoWqfXZWSPo40z187VLoExWmzAtXaLasAZBeRAt6ZzSoTOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778149663; c=relaxed/simple;
	bh=/AIkny8nLJpIQEYRObf+lKVG0n9GE0c7+ds4ju7J03w=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=DcEakvhY3XILQ9Y+33O9n6OPgt7NDt8LC6REMX+881lWPKCE0M6BEiY0cuc32BIgMrNwgZiSFhkIEKQnmm83D5xTox2aJx2Mi0mLI7noUsHdr9o6IxNKDNAebLHjeuwg8G0prRCuyGBKh2cd8lUwHeKUEm3o3VE52z5E5d+/qdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=nyiLWG2O; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="nyiLWG2O"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 14161240658
	for <linux-scsi@vger.kernel.org>; Thu,  7 May 2026 12:27:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.net; s=2017;
	t=1778149653; bh=/AIkny8nLJpIQEYRObf+lKVG0n9GE0c7+ds4ju7J03w=;
	h=MIME-Version:Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Transfer-Encoding:From;
	b=nyiLWG2Of7IsS0F2+P5kv27dgMWF3Jnm27SpkpWPcTAFCIF3gthf+tHE2xDEVYZDA
	 72gXW5uQQTSw6WMEZSylZ9i9VvuswSmC9dvAWX46am3fMOCnUy0tb/rB+Oz3AOMnAo
	 3wh6V3SgvvmVGoAwixO99EjAzLJw8zEpeqF27FPebXv5U/0XRxqsv/h3381rHBb24o
	 +TF6iO0P5rPQ0A3HZeTLpWyI+qlNBrwPCGMA4wFvjywBENVs7+uBLOpvL3wfssJflR
	 jwp6POmYFjBTqGUi7dVJkeDl3z6t46mU/NqczCKGOnn6g6uFQzPaH0LADxa+W5YSBB
	 fEqSZClejt1Ig==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4gB7jc2VG6z6tx5;
	Thu,  7 May 2026 12:27:32 +0200 (CEST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 07 May 2026 10:27:32 +0000
From: mateusz.nowicki@posteo.net
To: Laurence Oberman <loberman@redhat.com>
Cc: don.brace@microchip.com, martin.petersen@oracle.com,
 James.Bottomley@hansenpartnership.com, storagedev@microchip.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: smartpqi: fix PCIe hot reset recovery
In-Reply-To: <9b49bda9e8e3dce89eaf969f452ddd2315c2f953.camel@redhat.com>
References: <cover.1778075755.git.mateusz.nowicki@posteo.net>
 <9624a8d152197522d353ef7bb2b4928d1c6238ae.camel@redhat.com>
 <9b49bda9e8e3dce89eaf969f452ddd2315c2f953.camel@redhat.com>
Message-ID: <de98e42a98e8f4ba71735593b3d73b6d@posteo.net>
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: quoted-printable

Hello,

Thank you Laurence, appreciated. I'll add your Tested-by and Reviewed-by
to both patches in v2 if the series needs a respin; otherwise Don or=20
Martin
will pick it up on apply.

Thanks,
Mateusz

On 07.05.2026 03:45, Laurence Oberman wrote:
> On Wed, 2026-05-06 at 18:21 -0400, Laurence Oberman wrote:
>> On Wed, 2026-05-06 at 14:01 +0000, Mateusz Nowicki wrote:
>> > A PCIe bus reset (e.g. "echo 1 > /sys/bus/pci/devices/<bdf>/reset")
>> > on a
>> > controller without FLR support leaves the HPE SR932i-p Gen10+
>> > unusable
>> > until reboot: smartpqi registers no pci_error_handlers, so the
>> > driver
>> > is not notified, firmware reverts to SIS mode, and all queue
>> > mappings
>> > are dropped while the driver still drives PQI.
>> >
>> > Patch 1 adds .reset_prepare / .reset_done reusing
>> > pqi_ofa_ctrl_quiesce() / _unquiesce() / pqi_ctrl_init_resume().
>> >
>> > Patch 2 raises SIS_CTRL_READY_RESUME_TIMEOUT_SECS from 90s to 180s,
>> > matching the cold-boot path; without this patch 1 fails at the SIS
>> > ready check because firmware boot after reset takes ~125s on the
>> > SR932i-p Gen10+.
>> >
>> > Tested on HPE SR932i-p Gen10+ against Linus' master at
>> > 74fe02ce122a.
>> >
>> > Note: the From: header is my Posteo address because my employer's
>> > SMTP
>> > is unavailable for external mailing lists.=C2=A0 The Signed-off-by
>> > carries
>> > the Microchip attribution.
>> >
>> > Mateusz Nowicki (2):
>> > =C2=A0 scsi: smartpqi: add pci_error_handlers for bus reset recovery
>> > =C2=A0 scsi: smartpqi: increase SIS ctrl ready resume timeout to 180s
>> >
>> > =C2=A0drivers/scsi/smartpqi/smartpqi_init.c | 47
>> > +++++++++++++++++++++++++++
>> > =C2=A0drivers/scsi/smartpqi/smartpqi_sis.c=C2=A0 |=C2=A0 2 +-
>> > =C2=A02 files changed, 48 insertions(+), 1 deletion(-)
>> >
>> > --
>> > 2.43.0
>> >
>> >
>> >
>> Hello
>>=20
>> I did reproduce this so I am testing the patches as well.
>> They look correct to me, I will reply again after testing with a
>> review.
>>=20
>> Thanks
>> Laurence
>>=20
>>=20
>> [2513778.140012] smartpqi 0000:64:00.0: no heartbeat detected - last
>> heartbeat count: 4207808511
>> [2513778.140031] smartpqi 0000:64:00.0: controller offline: reason
>> code
>> 0x4 (no controller heartbeat detected)
>> [2513778.141346] sd 1:0:0:0: [sda] tag#549 FAILED Result:
>> hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK cmd_age=3D18s
>> [2513778.141355] sd 1:0:0:0: [sda] tag#550 FAILED Result:=C2=A0
>>=20
>> "xfs_buf_ioend_handle_error+0xd5/0x3f0 [xfs]" at daddr 0x9f78 len 8
>> error 5
>> [2513778.141526] XFS (dm-0): log I/O error -5
>>=20
>=20
> Hello
>=20
> For the series:
>=20
> I tested the patches and it recovers with them applied.
> The patches look good.
>=20
> Tested-by: Laurence Oberman <loberman@redhat.com>
> Reviewed-by: Laurence Oberman <loberman@redhat.com>
