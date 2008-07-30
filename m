From: Mike Miller <mike.miller@hp.com>
Subject: Problems building 2.6.26 and 2.6.27-rc1
Date: Wed, 30 Jul 2008 13:48:33 -0500
Message-ID: <20080730184833.GA936@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:33624 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYG3Ssg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 14:48:36 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML-scsi <linux-scsi@vger.kernel.org>

I'm getting the following error when trying to build either 2.6.26 or
2.6.27-rc1:

arch/x86/kernel/head64.c: In function =E2=80=98x86_64_start_kernel=E2=80=
=99:
arch/x86/kernel/head64.c:88: error: size of array =E2=80=98type name=E2=
=80=99 is negative

Systems I've tried are DL585 G5 with dual-core Opterons and ML370 G5 wi=
th
dual-core Intel. Both were originally installed using an x86_64 distro.

Anybody else seen this? Any workarounds?

Thanks,
mikem
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
