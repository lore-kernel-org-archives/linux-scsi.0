From: Michael Renner <michael.renner@geizhals.at>
Subject: Lack of procfs support in 3w-xxxx 1.26.02.000
Date: Tue, 28 Dec 2004 09:19:50 +0100
Message-ID: <41D11726.5050109@geizhals.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from home.geizhals.at ([213.229.14.34]:21951 "EHLO
	morework.geizhals.at") by vger.kernel.org with ESMTP
	id S261761AbUL1ITv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Dec 2004 03:19:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxraid@amcc.com
Cc: linux-scsi@vger.kernel.org

Hi Adam,

I recently upgraded to 2.6.10 only to notice that procfs support was=20
removed from 3w-xxxx 1.26.02.000, apparently causing tw_cli to fail=20
(tried with the most recent 2.00.00.032b and an older 2.00.00.015).

Will this be fixed in the driver or is there a new tw_cli going to be=20
released soon? I don't like having my arrays flying blind.

--=20

best regards,
  Michael Renner - Network services

Preisvergleich Internet Services AG
Obere Donaustra=DFe 63/2, A-1020 Wien
Tel: +43 1 5811609 80
=46ax: +43 1 5811609 55
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
