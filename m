From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: TMSCSIM [2.6]
Date: Sat, 29 Nov 2003 14:06:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3r7zr1g05.fsf@merlin.emma.line.org>
References: <Pine.LNX.4.44.0311291030500.1672-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dt.E-Technik.Uni-Dortmund.DE ([129.217.163.1]:35048 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S263205AbTK2NGF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2003 08:06:05 -0500
Received: from m2a2.dyndns.org (krusty.dt.e-technik.uni-dortmund.de [129.217.163.1])
	by mail.dt.e-technik.uni-dortmund.de (Postfix) with ESMTP id 1AB9615D5C
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2003 14:06:04 +0100 (CET)
In-Reply-To: <Pine.LNX.4.44.0311291030500.1672-100000@poirot.grange> (Guennadi
 Liakhovetski's message of "Sat, 29 Nov 2003 10:46:24 +0100 (CET)")
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Chiaki <ishikawa@yk.rim.or.jp>, linux-scsi@vger.kernel.org, Thorsten Leemhuis <Thorsten_Leemhuis@gmx.de>, gl@dsa-ac.de

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> PS: now that the driver seems to be in better shape, you might want to
>> bump the driver version number  reported in the banner,
>> "Tekram DC390/AM53C974 PCI SCSI Host Adapter, Driver Version 2.0f
>> 2000-12-20".
>
> Yep. Kurt, Christian, shall I increment the version number (2.0g / 2.1a?),
> adding a Changelog entry? Also, how shall it be maintained now, until it
> is included in the stock 2.6 (hopefully)? Is there a linux-scsi tree,
> where this driver could be merged in, or just an ftp site, where the patch
> could be uploaded? I am not using BK (don't think it would make much sense
> with a 56K modem dial-up:-)).

Guennadi,

Please bump the version, I'd choose 2.0f-gl1 (where gl are your initials
and 1 is the first "release" you deem stable).

If some maintainer (Kurt? 2.6-SCSI-bugfixes maintainer?) wants a
different version, he shall have the last word and can still choose a
different version string.

Thanks,

-- 
Matthias Andree

Encrypt your mail: my GnuPG key ID is 0x052E7D95
