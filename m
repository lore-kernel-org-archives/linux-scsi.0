From: linux@highpoint-tech.com
Subject: Question about driver category for submission
Date: Tue, 5 May 2015 13:00:54 -0400 (EDT)
Message-ID: <1430845254.106831601@apps.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.iad3a.emailsrvr.com ([173.203.187.126]:58808 "EHLO
	smtp126.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933304AbbEERGl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 May 2015 13:06:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

Hello,
We would like to submit our driver for Linux kernel embedded. Our produ=
ct is using Marvell 9480/9495 SAS/SATA controller with Marvell Port Mul=
tiplier(PM) controller to provide PM feature for SATA HDDs. From driver=
 source package, we found the Marvell has provided =E2=80=9Cmvsas=E2=80=
=9D source package that covers this chip. But here are questions

1.  The =E2=80=9Cmvsas=E2=80=9D is based on SCSI modules so it links to=
 scsi library where it doesn=E2=80=99t support PM feature
2.  We use the same controller chip, so we can=E2=80=99t have the code =
in other category.=20
3. To use PM feature, we need to link to SATA library

Our current code is proprietary which uses scsi module and add PM and s=
taggered drive spin up features. Hence, this question is to ask Linux c=
ommunity to tell us how should we proceed this if we want to open our c=
ode and get driver embedded? Do we need to add our code based on mvsas =
source? How do we include SATA library in scsi module? or other alterna=
tives?


Best Regards,
HighPoint Linux Team=20





--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
