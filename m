From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH v2] SG_SCSI_RESET ioctl: add no_escalate values
Date: Fri, 22 Feb 2013 15:30:11 -0600
Message-ID: <5127E363.9060100@tributary.com>
References: <511FD7DE.3040606@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.58]:19118 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324Ab3BVVaS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Feb 2013 16:30:18 -0500
In-Reply-To: <511FD7DE.3040606@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Tested-by: Jeremy Linton jlinton@tributary.com


I tested this patch in an environment where the lun and target reset is
"failing" because the target device is misbehaving.

This patch appears to work as advertised.



That said, I changed my testing methodology for this patch (vs the one I
originally posted). The results were "interesting", there are some really
strange things that happen in some of the LLD error paths. Its obvious that
error injection is not part of testing many of them, and what at first glance
should be a fairly straightforward error can create quite a mess. So anyone
sending any kind of reset (especially without the ESCALATE flag which tends to
isolate the error handling) to the LLD's should be aware that behavior between
them can vary significantly.










-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRJ+NjAAoJEL5i86xrzcy7GI0H/2XKCZvhLmE8WeQtMXlHhVyA
G3Y34fKeEx9ek56Sr6AcipvV9mUBR9uYvydxZfdGjBT83I2bYGRHEfVEx22WKFXr
JShVv43eIl5y/inUr8THNTBfggFcYaBIx21ieLwvR/+cBGWbpiIwi16ktaENX2O7
nHgHVSvFOam9Qy8ewQ2YcULsGFkHQd1SN2LXKSh5bp42eZ998Od4t+agADlNipNz
OShNyJO9fHr4XC/pNMdujjDd+eaOPv5/furYAgkU/aQutxjIs5a0OtDiNi0hzmQ+
ZVfoQWk4Bh4LJdQ2ZiqiKBi54z8YxJu5n2WmbKTzwWcabumOWqebNG8JaYDDYjI=
=2mMo
-----END PGP SIGNATURE-----
