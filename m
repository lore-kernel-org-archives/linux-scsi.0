From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: add Synology DSM 6.0 and higher to 1024 sector blacklist
Date: Mon, 25 Apr 2016 22:12:20 -0400
Message-ID: <yq1wpnlgltn.fsf@sermon.lab.mkp.net>
References: <20160114003437.354D28EE1D4@bedivere.hansenpartnership.com>
	<570B63B8.6080104@tcnnet.com> <yq1oa9fzhyi.fsf@sermon.lab.mkp.net>
	<570CB1C8.5050106@tcnnet.com> <yq17fg2zn1q.fsf@sermon.lab.mkp.net>
	<570D4A19.40000@redhat.com> <yq137qqzl6f.fsf@sermon.lab.mkp.net>
	<571741F5.7060305@tcnnet.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22012 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbcDZCMc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2016 22:12:32 -0400
In-Reply-To: <571741F5.7060305@tcnnet.com> (Michel Meyers's message of "Wed,
	20 Apr 2016 10:46:45 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michel Meyers <steltek@tcnnet.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>, linux-scsi@vger.kernel.org

>>>>> "Michel" == Michel Meyers <steltek@tcnnet.com> writes:

Michel> I am currently running tests with an unmodified Debian
Michel> 4.4.0-1-amd64 kernel, so unless I can reproduce the problem, I
Michel> suggest we leave the current blacklist as is (thereby only
Michel> quirking the pre-6.0 SYNOLOGY volumes that are affected) and
Michel> discard the new patch.

Sounds good to me. Thanks for the update!

-- 
Martin K. Petersen	Oracle Linux Engineering
