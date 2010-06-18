From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: HighPoint Technologies, Inc. Device [1103:2680]
Date: Fri, 18 Jun 2010 15:18:47 +0200
Message-ID: <20100618151847.68abad65@harpe.intellique.com>
References: <4C1B612C.8070503@powercraft.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:34930 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758377Ab0FRNSt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2010 09:18:49 -0400
In-Reply-To: <4C1B612C.8070503@powercraft.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jelle de Jong <jelledejong@powercraft.nl>
Cc: linux-scsi@vger.kernel.org, linux@highpoint-tech.com

Le Fri, 18 Jun 2010 14:06:04 +0200
Jelle de Jong <jelledejong@powercraft.nl> =E9crivait:

> It seems there is no kernel module for the 2600 series or the 2700
> series. The HighPoint website [1][2] keeps claiming there are open
> soure drivers available. I know open source is not the same as free
> software, but it is very very misleading, because it does not work.

Usually Highpoint labels "open source" a code source wrapper around a
proprietary piece of driver. HighPoint are really horrible from a free
software POV and really stink under linux; and as they aren't true
hardware RAID but use a substantial part of the driver to do their job
there isn't much hope that it will ever get any better. My advice :
stay away from these, use any of 3Ware, Areca or Adaptec SAS/SATA
controllers which all work fine and without hassle under Linux.

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
