From: Phillip Susi <psusi@ubuntu.com>
Subject: Dynamic scsi_debug module
Date: Fri, 07 Feb 2014 14:27:23 -0500
Message-ID: <52F5339B.7070503@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:62176 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaBGT10 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 14:27:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Is it possible to use the scsi_debug module to create more than one
device?  It seems to me that it needs rewritten to have an interface
to dynamically create devices and set their parameters with a tool
like losetup, rather than using module parameters.

I found some references to being able to load certain modules multiple
times using modprobe -o,  but this option does not seem to exist.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS9TOaAAoJEI5FoCIzSKrwEPAH/07+mgbvCIYfJ60DPoZAOIoa
tN5D0ABI1Qw3DGIUqHQcdT9pUDcGdXRfO+akBtsvmCGQGI3W7lZphVzie1OwhAEq
OiEbeT07EbLCGhP/UY9tmKssAXjeai7UZrbUDfvuvxSgBEmqFzCxyGHMCOAG7pfj
iYW38h1xiMq7vZyttSJ4yIFDJnm9IAa8+lemhnqs2XPwzrmpod2yfgJcm4cpxkfY
Mcix+qw7YhBNNtuHXk7BSgQDEB01w1dB4jjmTzH0VwUsbf4F45zq5IvI21f/m7DO
9Tzsvhd3DVDgYYpEMJTgnuts9vE0L8hX5xjE50QlT7/izv1XR9gVSwgh8PJOA74=
=GLCo
-----END PGP SIGNATURE-----
