From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: TMSCSIM [2.6]
Date: Sat, 29 Nov 2003 21:37:48 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311292126060.529-100000@poirot.grange>
References: <m3r7zr1g05.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:26018 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263408AbTK2Ui4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2003 15:38:56 -0500
In-Reply-To: <m3r7zr1g05.fsf@merlin.emma.line.org>
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Cc: Chiaki <ishikawa@yk.rim.or.jp>, linux-scsi@vger.kernel.org, Thorsten Leemhuis <Thorsten_Leemhuis@gmx.de>, gl@dsa-ac.de

On Sat, 29 Nov 2003, Matthias Andree wrote:

> Please bump the version, I'd choose 2.0f-gl1 (where gl are your initials
> and 1 is the first "release" you deem stable).

Yeah-yeah, I know what "gl" means - as well as anybody living / working in
Germany does:-) It's one of favorite jokes in the company, I am working
for (see my working email address in the CC-list).

> If some maintainer (Kurt? 2.6-SCSI-bugfixes maintainer?) wants a
> different version, he shall have the last word and can still choose a
> different version string.

Ok, version string is one of the smallest problems, the real question is -
what to do with the patch? Just post it to the list, so that one of
maintainers could pick it up and include in his / her tree?

Also, would be nice if somebody could test this driver on a highmem-PC,
and on non i386 platforms...

Well, it has been fun. I guess, I could try to fill in those "TODOs" Kurt
has inserted in the code. But that will be for -gl2. Otherwise, there are
quite a few more SCSI drivers, depending on BROKEN. Do any of them need
fixing and currently have nobody to do the work or they are there just
waiting to be removed? Anyway, I don't have any of that hardware at
hand...

Thanks
Guennadi
---
Guennadi Liakhovetski


