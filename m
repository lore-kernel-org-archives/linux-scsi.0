From: Erno Kovacs <erno.kovacs@freemail.hu>
Subject: Re[2]: HighPoint Technologies, Inc. Device [1103:2680]
Date: Sat, 19 Jun 2010 09:25:05 +0200
Message-ID: <303578841.20100619092505@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep21.mx.upcmail.net ([62.179.121.41]:24597 "EHLO
	fep21.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab0FSHmZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Jun 2010 03:42:25 -0400
Received: from edge04.upcmail.net ([192.168.13.239])
          by viefep16-int.chello.at
          (InterMail vM.8.01.02.02 201-2260-120-106-20100312) with ESMTP
          id <20100619072512.OOIJ26979.viefep16-int.chello.at@edge04.upcmail.net>
          for <linux-scsi@vger.kernel.org>; Sat, 19 Jun 2010 09:25:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

> Le Fri, 18 Jun 2010 14:06:04 +0200
> Jelle de Jong <jelledejong@powercraft.nl> =E9crivait:

>> It seems there is no kernel module for the 2600 series or the 2700
>> series. The HighPoint website [1][2] keeps claiming there are open
>> soure drivers available. I know open source is not the same as free
>> software, but it is very very misleading, because it does not work.

> Usually Highpoint labels "open source" a code source wrapper around a
> proprietary piece of driver. HighPoint are really horrible from a fre=
e
> software POV and really stink under linux; and as they aren't true
> hardware RAID but use a substantial part of the driver to do their jo=
b
> there isn't much hope that it will ever get any better. My advice :
> stay away from these, use any of 3Ware, Areca or Adaptec SAS/SATA
> controllers which all work fine and without hassle under Linux.

Its true, although newer HPT series have real IO processors.
Anyway, 2600 and 2700 serie seem to have Marvell chipset, which should
work with the mvsas driver, but unfortunately it still has some
stability issues according to mailing-list posts here, even after
patchset of Srinivas applied.

Erno

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
