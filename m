Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799A32EBB86;
	Wed, 25 Mar 2026 06:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774421678; cv=none; b=IT+lgyVZeQeppFkcRSlVt4zlTemcoq3VLwvdLEcV5r3CP6FItkx1siVNjbOHYWxPChQHjNdH7qZlgJvZGFIKJOjjILipHviAPlh8xIAVwWiSEvko4NN8A2NMARLpj2h0WxeZJBcwpxJvwEePmdtLkugMDLZWZZ6+aFZ+vpbDNik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774421678; c=relaxed/simple;
	bh=7yrgxLgcofjYfXPB0dzHihqRPi878IL1CHOcBcZqNw0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TXwI46Hy10G208pvzVhUj2F5ol+nb83z+UoniIWF8F0AbjiGSaaKivJBHoBJvoVL2HArf67zsvZAutjvw2cRd2JYnTph3OrL00Nb4vMdGgOySxHEGI6A2/sdVSggLqaqXYphj+/RfmfgytKjSw73gK5mqGi/J08fOkvkfzAv3Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=felix.busch1@gmx.net header.b=tIhlwlqK; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=felix.busch1@gmx.net header.b="tIhlwlqK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1774421674; x=1775026474; i=felix.busch1@gmx.net;
	bh=NyX+n5c4AwJMEgI1t6DOX5kHXsJWOkKh7nPsI/m0jFI=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=tIhlwlqK0ZmV6X09n7N12YvTi3eerMW4g1iVfhuKMKczwR3IwicHFjiIdjRjxnqP
	 dtBMBWpzbav7v72jcOtDdAZtb9Qyyh0jVMqJ+n8r6hz3J8oiz9li1KHSvIP3SW5CY
	 AK/n7fh0K/srvZTF/GCrB/yk9qjiy0kDkZjFe5R+RpfCDg2sqfVwgeVvRNnZCVhvE
	 SnvYk7DEI5pYGjMZY8a3iCJro6RUEcwTjGKl3UBaraG+o1md/vx8o/HQpzqJxk4pb
	 PFfbroV+IMrlvJ+XIYS+C8vaXuH7qKdNicDvaCsGQM8jUK5fA67iZWBNf5rvevPjw
	 /kBwWu11vbLJsZrEHQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N6KYb-1vTbwh0OZV-00y4rO; Wed, 25
 Mar 2026 07:54:34 +0100
From: Felix Busch <felix.busch1@gmx.net>
To: phil@philpotter.co.uk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Felix Busch <felix.busch1@gmx.net>
Subject: [PATCH 0/1] *** CD-ROM: LBA bound check in mmc_ioctl_cdrom_read_data ***
Date: Wed, 25 Mar 2026 07:53:34 +0100
Message-ID: <20260325065335.7783-1-felix.busch1@gmx.net>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:OPs73uUpOk40Aw94CSWc7nHworUIEg5BqFSuMVSYcjZshFDDMjj
 sVsVAqFdgtkCSFQdM5YbeFvNCoxktNJiBqmCWFOfMzVRJtcH1duSLKqMyPQ6EuHVC2tIx13
 9EwJnORtc994pWMsdnVbUoc+RJbd/w7FLeLFJTc09/PRPm3aBZDARIFXMkRLOUsgcxHFwvo
 C2hEeo0Ixo84zpWOcgrTQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:rpTGaBuh/3I=;bAaLkDbcc+qxcvFnnTRLVE4EjOn
 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

This introduces an upper-bound check for the Logical Block Address (LBA) i=
n mmc_ioctl_cdrom_read_data=20
within the CD-ROM driver. The change is motivated by two main reasons: fir=
st, there is currently no=20
upper-bound check in place; second, adding this check can help improve exe=
cution performance.

There has already been a prior discussion on this topic about this check i=
n mmc_ioctl_cdrom_read_data,=20
but this patch follows a slight different approach, due a missunderstading=
 in the SCSI-2=20
documentation. (https://www.staff.uni-mainz.de/tacke/scsi/SCSI2-14.html)

Blocks are addressed here using a zero-based integer index. Therefore, it =
should be possible to check,=20
that the LBA falls within the range 0 to N =E2=88=92 1, where N represents=
 the total number of available blocks.

To get the number of blocks in mmc_ioctl_cdrom_read_data, a small inline f=
unction
has been added to access the capacity field of the scsi_cd struct, which a=
lready contains the
size in blocks available on the CD-ROM. The main reason for this addition =
is, that
it might be more performant accessing the value there, rather than recalcu=
lating the number=20
of blocks again in mmc_ioctl_cdrom_read_data. Maybe there's another possib=
ility of doing that,=20
which I'm not aware of yet.

While examining the CD-ROM capacity, I noticed, that get_sectorsize change=
s the capacity value
by multiplying the current set value with four.
```
cd->capacity *=3D 4;
```
On the tested CD-ROM hardware, keeping this multiplication resulted in an =
incorrect CD-ROM capacity being reported.
With the line disabled, the capacity appears to be accurate. However, I'm =
not 100% sure whether this adjustment
may affect other hardware that rely on the original behavior.

One benefit of having an upper bound check for the LBA might be the execut=
ion duration of mmc_ioctl_cdrom_read_data.
With this check applied, mmc_ioctl_cdrom_read_data took an average of 0.22=
17 milliseconds, compared to 6.006 milliseconds
without the check. This performance improvement was observed specifically =
when the LBA exceeded the number of available
blocks, and the CD-ROM contained actual written data.

Thank you for your time.

Felix Busch (1):
CD-ROM: Additional LBA bound check

drivers/cdrom/cdrom.c |  7 +++++--
drivers/scsi/sr.c     | 12 +++++++++++-
include/linux/cdrom.h |  2 ++
3 files changed, 18 insertions(+), 3 deletions(-)

=2D-=20
2.53.0

