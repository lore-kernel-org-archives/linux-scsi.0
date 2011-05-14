From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: aacraid adaptec 6805 support?
Date: Sat, 14 May 2011 12:20:45 +0200
Message-ID: <20110514122045.6019d4c2@galadriel2.home>
References: <20110513141242.GA1048@apartia.fr>
	<20110513164922.5167ea53@harpe.intellique.com>
	<20110513145420.GA2797@apartia.fr>
	<20110513172457.0db50c93@harpe.intellique.com>
	<20110513153922.GA5041@apartia.fr>
	<20110513183356.64937c6d@harpe.intellique.com>
	<20110514062533.GA13324@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:58909 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076Ab1ENKVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 May 2011 06:21:23 -0400
In-Reply-To: <20110514062533.GA13324@apartia.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Le Sat, 14 May 2011 08:25:33 +0200 vous =C3=A9criviez:

> And in that "legacy" mode the disk geometry appears slightly smaller
> to the OS than with the LSI controller, hence my problem
> with /dev/md2.

Yes, some controllers reserve out a part of the drive to allow for
using slightly different drives to repair the array. Unfortunately that
parameter may or may not be user-tunable.

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
