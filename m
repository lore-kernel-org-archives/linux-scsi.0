From: =?utf-8?Q?Edgaras_Luko=C5=A1evi=C4=8Dius?=
	<edgaras.lukosevicius@gmail.com>
Subject: iSCSI bug
Date: Thu, 5 Mar 2015 17:56:56 +0200
Message-ID: <D5289E78-CABB-4E26-A28B-7F0F04EFFEAD@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:39510 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939AbbCEP5t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2015 10:57:49 -0500
Received: by wghn12 with SMTP id n12so102506wgh.6
        for <linux-scsi@vger.kernel.org>; Thu, 05 Mar 2015 07:57:48 -0800 (PST)
Received: from [192.168.168.7] ([37.157.144.44])
        by mx.google.com with ESMTPSA id md2sm2263229wic.19.2015.03.05.07.57.47
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 05 Mar 2015 07:57:48 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello,

we have a problem. iscsi connection is dropping constantly. After enabl=
ing iscsi debug following message popped up after iscsi connection got =
lost:

# Kernel
3.18.6-1.el7.elrepo.x86_64

Message from syslogd@storage-1 at Mar  5 15:55:12 ...
 kernel:NMI watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [iscsi_tr=
x:11958]

Message from syslogd@storage-1 at Mar  5 15:55:40 ...
 kernel:NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [iscsi_tr=
x:11958]

Message from syslogd@storage-1 at Mar  5 15:56:08 ...
 kernel:NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [iscsi_tr=
x:11958]

Message from syslogd@storage-1 at Mar  5 15:56:48 ...
 kernel:NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [iscsi_tr=
x:11958]


P.S.

Kernel 3.19 acts same I just don=92t have debug messages for it. --
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
