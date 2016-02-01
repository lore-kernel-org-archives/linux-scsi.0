From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: scsi_debug, iosize optimal < minimum
Date: Mon, 01 Feb 2016 07:13:27 -0500
Message-ID: <yq1fuxcr5lk.fsf@sermon.lab.mkp.net>
References: <201601291131.29201.sweet_f_a@gmx.de>
	<20160129113110.o76pvon3wormblgd@ws.net.home>
	<201601291402.14306.sweet_f_a@gmx.de>
	<201601291718.21185.sweet_f_a@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48229 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbcBAMNg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2016 07:13:36 -0500
In-Reply-To: <201601291718.21185.sweet_f_a@gmx.de> (Ruediger Meier's message
	of "Fri, 29 Jan 2016 17:18:20 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ruediger Meier <sweet_f_a@gmx.de>
Cc: Karel Zak <kzak@redhat.com>, util-linux@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>

>>>>> "Ruediger" == Ruediger Meier <sweet_f_a@gmx.de> writes:

Ruediger> I've noticed a possible problem with scsi_debug devices where
Ruediger> optimal_io_size < minimum_io_size.

Ruediger> The problem seems reproducable with kernel 4.4.0 and also with
Ruediger> stable version 4.1.15. For stable tree the last known working
Ruediger> version is 4.1.13.

http://git.kernel.org/cgit/linux/kernel/git/mkp/scsi.git/commit/?h=4.5/scsi-fixes&id=d0eb20a863ba7dc1d3f4b841639671f134560be2

-- 
Martin K. Petersen	Oracle Linux Engineering
