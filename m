From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: aacraid adaptec 6805 support? [sorry if double post...]
Date: Fri, 13 May 2011 18:33:56 +0200
Message-ID: <20110513183356.64937c6d@harpe.intellique.com>
References: <20110513141242.GA1048@apartia.fr>
	<20110513164922.5167ea53@harpe.intellique.com>
	<20110513145420.GA2797@apartia.fr>
	<20110513172457.0db50c93@harpe.intellique.com>
	<20110513153922.GA5041@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:37234 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab1EMQdz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2011 12:33:55 -0400
In-Reply-To: <20110513153922.GA5041@apartia.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Le Fri, 13 May 2011 17:39:22 +0200
Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org> =E9crivait=
:

> On each disk the third partition /dev/sdX3 is the last and largest bu=
t
> it seems the Adaptec controller doesn't "see" the end of the disk
> where the md superblock is? Does that make sense?

Not to me, but I've seen weirder things from Adaptec firmwares :)
Are the drives configured as JBOD, or something else? You may segment
the drives (for instance if their sizes differ slightly), so maybe some
of them appear as volume segments instead of JBOD?

> When booting the controller lists all disks in "legacy" mode. What
> does that mean vs JBOD?

I have no idea. However I've seen adapters from different builders
partly (and wrongly) recognize each other on-disk headers. I've
recently moved a bunch of disks from an LSI 9200 4i4e to an Adaptec
6445, but I don't remember of any particular weirdness.

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
