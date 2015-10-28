From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 02/12] megaraid_sas : Code optimization- remove PCI Ids based checks
Date: Tue, 27 Oct 2015 22:33:02 -0400
Message-ID: <yq1si4v90yp.fsf@sermon.lab.mkp.net>
References: <201510150816.t9F8GqPJ029555@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50556 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbbJ1Cdm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2015 22:33:42 -0400
In-Reply-To: <201510150816.t9F8GqPJ029555@palmhbs0.lsi.com> (sumit saxena's
	message of "Thu, 15 Oct 2015 13:39:34 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sumit.saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, kiran-kumar.kasturi@avagotech.com, uday.lingala@avagotech.com

>>>>> "Sumit" == sumit saxena <sumit.saxena@avagotech.com> writes:

Sumit> Code optimization: remove PCI id based checks and instead of
Sumit> those use instance->ctrl_context to make call whether controller
Sumit> is MFI based OR fusion adapter.  fusion adapters further are also
Sumit> divided in two categories- 1)THUNDERBOLT SERIES and 2)INVADER
Sumit> SERIES.

Does not apply against current upstream. Please fix and repost.

-- 
Martin K. Petersen	Oracle Linux Engineering
