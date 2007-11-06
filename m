From: Erez Zilber <erezz@Voltaire.COM>
Subject: usage of max_sectors in scsi_host_template
Date: Tue, 06 Nov 2007 13:22:24 +0200
Message-ID: <47304E70.9090005@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fwil.voltaire.com ([193.47.165.2]:12410 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752201AbXKFLit (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Nov 2007 06:38:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm not sure that I understand the meaning of max_sectors in=20
scsi_host_template. Is it the maximum data length of a single SCSI=20
command? Is it in bytes? What's the size of a sector?


Thanks,

--=20

____________________________________________________________

Erez Zilber | 972-9-971-7689

Software Engineer, Storage Solutions

Voltaire =96 _The Grid Backbone_

__

www.voltaire.com <http://www.voltaire.com/>


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
