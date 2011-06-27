From: DemonCcC <demonccc@gmail.com>
Subject: megaraid_sas driver issues
Date: Mon, 27 Jun 2011 14:48:19 -0300
Message-ID: <BANLkTiknooRPVHzPFjHu-w+db=EhG-sxXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:38383 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab1F0RsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2011 13:48:19 -0400
Received: by yia27 with SMTP id 27so1926520yia.19
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2011 10:48:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I have installed Debian on PowerEdge R710 Dell system.

I upgrade the storage controller (LSI MegaRAID SAS 1078) to the last
firmware version that Dell provides (6.3.0-0001). The server has two
storage controllers, one internal (PERC 6/i Integrated) and other
external ( PERC 6/E Adapter).

With the kernels 2.6.35, 2.6.38 and 2.6.39 the kernel returns these mes=
sages:

Jun 24 21:41:44 mysql01 kernel: [   29.428857] megaraid_sas
0000:03:00.0: vpd r/w failed.  This is likely a firmware bug on this
device.  Contact the card vendor for a firmware update.
Jun 24 21:41:45 mysql01 kernel: [   29.817765] megaraid_sas
0000:0a:00.0: vpd r/w failed.  This is likely a firmware bug on this
device.  Contact the card vendor for a firmware update.

The kernel 2.6.32 doesn't return any error.

I tested with the pci=3Dnocrs, because I have read that the default is
pci=3Duse_crs in the newest kernel and it could cause a timeout when th=
e
kernel tries to read the vpd, but the kernel still logging these
messages.

Also I compiled the latest megaraid_sas driver (00.00.05.38-rc1) but
these messages keep appearing.

Do you know what could be the issue? Why the newest kernels log these m=
essages?

Regards.

Claudio C=E9sar S=E1nchez Tejeda
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
