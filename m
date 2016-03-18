From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] megaraid_sas: add missing curly braces in ioctl handler
Date: Fri, 18 Mar 2016 15:23:50 -0400
Message-ID: <yq14mc3a8u1.fsf@sermon.lab.mkp.net>
References: <1457965789-3373916-1-git-send-email-arnd@arndb.de>
	<1457965789-3373916-4-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39207 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbcCRTYH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2016 15:24:07 -0400
In-Reply-To: <1457965789-3373916-4-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Mon, 14 Mar 2016 15:29:45 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, megaraidlinux.pdl@avagotech.com

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> gcc-6 found a dubious indentation in the megasas_mgmt_fw_ioctl
Arnd> function:

Applied to 4.6/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
