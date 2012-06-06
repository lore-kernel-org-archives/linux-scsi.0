From: Denny Schierz <linuxmail@4lin.net>
Subject: Re: 3.3.0/3.4.1 | 53c1030 PCI-X Fusion-MPT | mptbase: ioc0: LogInfo(0x11010000): F/W: bug! MID not found
Date: Wed, 6 Jun 2012 13:42:48 +0200
Message-ID: <825C042F-9868-48E4-AEF1-B6FF20FA5E06@4lin.net>
References: <DE50C1A5-85F6-4B84-B77F-BCED651D2EB5@4lin.net> <20120606133435.16a502b8@harpe.intellique.com>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.4lin.net ([46.4.210.97]:41367 "EHLO mail.4lin.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab2FFLmy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jun 2012 07:42:54 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.4lin.net (Postfix) with ESMTP id B5E5D3903C
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jun 2012 13:47:47 +0200 (CEST)
Received: from mail.4lin.net ([127.0.0.1])
	by localhost (mail.4lin.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F3f109xfIrKo for <linux-scsi@vger.kernel.org>;
	Wed,  6 Jun 2012 13:47:44 +0200 (CEST)
Received: from pcdenny.rbg.informatik.tu-darmstadt.de (pcdenny.rbg.informatik.tu-darmstadt.de [130.83.160.152])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mail.4lin.net (Postfix) with ESMTPSA id 0F52D20249
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jun 2012 13:47:44 +0200 (CEST)
In-Reply-To: <20120606133435.16a502b8@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Am 06.06.2012 um 13:34 schrieb Emmanuel Florac:

> Definitely looks like a bad disk to me. What is the RAID level used on
> the infortrend array? If it's RAID-0, look no further. Check your array
> messages and eventually cabling in any case.

Raid 5, and JBOD says, everything is O.K, no problem at all.

cu denny
