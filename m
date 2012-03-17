From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Burning multiple DVDs at one time
Date: Sat, 17 Mar 2012 11:53:24 +0100
Message-ID: <20120317115324.10b39bb7@galadriel.home>
References: <20120315225310.GB3152@animx.eu.org>
	<20120317095644.145d0588@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:49583 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756743Ab2CQKxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Mar 2012 06:53:55 -0400
In-Reply-To: <20120317095644.145d0588@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Wakko Warner <wakko@animx.eu.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Le Sat, 17 Mar 2012 09:56:44 +0100 vous =C3=A9criviez:

> This is likely due to serialization by a global mutex in the sr
> driver. Have a look at thread "[PATCH] [SCSI] sr: fix multi-drive
> performance, remove BKL replacement" from February.
> https://lkml.org/lkml/2012/2/28/230=20

When was this regression introduced? I have a dedicated cd burning
machine running 2.6.35.x, and it works great with 4 drives at a time.

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
