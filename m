From: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Subject: Add more debug output to sas_scsi_recover_host or sas_eh_handle_sas_errors
Date: Mon, 07 Apr 2008 16:22:19 +0200
Message-ID: <47FA2E1B.6020709@ipax.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ipax.at ([80.64.143.40]:36160 "EHLO mail.ipax.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394AbYDGOWV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Apr 2008 10:22:21 -0400
Received: from [192.168.1.110] (vie-078-142-128-152.dsl.sil.at [78.142.128.152])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ipax.at (Postfix) with ESMTP id 084B84773CA
	for <linux-scsi@vger.kernel.org>; Mon,  7 Apr 2008 16:22:21 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

hi,

is there any sens in adding more debug output to sas_scsi_recover_host
or sas_eh_handle_sas_errors?

e.g. put out SAS_ADDR(task->dev->sas_addr) so that we know whether
the error is always occuring on one phy/port/etc. ?

the reason for doing this is basically my problems with the aic94xx
driver, outlined in http://marc.info/?t=120603924200004.

cheers,
raoul
- --
____________________________________________________________________
DI (FH) Raoul Bhatia M.Sc.          email.          r.bhatia@ipax.at
Technischer Leiter

IPAX - Aloy Bhatia Hava OEG         web.          http://www.ipax.at
Barawitzkagasse 10/2/2/11           email.            office@ipax.at
1190 Wien                           tel.               +43 1 3670030
FN 277995t HG Wien                  fax.            +43 1 3670030 15
____________________________________________________________________
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH+i4bEaTXmVQ/cvsRAtLnAKCFPvCanPoq6+Fum4qqU3oR6/HXYACfQTBk
f4zXUKWVFOtTrLNxOdMNFzI=
=np9J
-----END PGP SIGNATURE-----
