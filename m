From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] pm80xx: remove the SCSI host before detaching from SAS transport
Date: Mon, 09 Nov 2015 19:44:20 -0500
Message-ID: <yq137wewumz.fsf@sermon.lab.mkp.net>
References: <1446235297-4572-1-git-send-email-brood@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45711 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbbKJAo1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2015 19:44:27 -0500
In-Reply-To: <1446235297-4572-1-git-send-email-brood@attotech.com> (Benjamin
	Rood's message of "Fri, 30 Oct 2015 16:01:37 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Rood <benjaminjrood@gmail.com>
Cc: linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, James.Bottomley@HansenPartnership.com, Benjamin Rood <brood@attotech.com>

>>>>> "Benjamin" == Benjamin Rood <benjaminjrood@gmail.com> writes:

Benjamin> Previously, when this module was unloaded via 'rmmod' with at
Benjamin> least one drive attached, the SCSI error handler thread would
Benjamin> become stuck in an infinite recovery loop and lockup the
Benjamin> system, necessitating a reboot.

Applied.

-- 
Martin K. Petersen	Oracle Linux Engineering
