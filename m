From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention handling
Date: Mon, 28 Jan 2013 09:52:51 -0600
Message-ID: <51069ED3.5010204@tributary.com>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com> <CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com> <51011D2E.305@suse.de> <CAO+b5-ptjPEbCrKEpdCEZBCh5Xs7ycXQA5V+iohAL4TSfbUzFg@mail.gmail.com> <5106939E.1010301@tributary.com> <51069CC8.3000103@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.58]:51578 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3A1Pwx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jan 2013 10:52:53 -0500
In-Reply-To: <51069CC8.3000103@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/28/2013 9:44 AM, Bart Van Assche wrote:
> when using Fibre Channel as transport layer. I'm looking for a solution 
> that also works with other SCSI transports, e.g. iSCSI and SRP.

	Doesn't iSCSI have a SNS server you can subscribe to that provides similar
functionality (name services and port add/remove)? SAS has the BROADCAST
functionality too which can act as an AEN.


	




-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRBp7TAAoJEL5i86xrzcy7jHAIAJlrqG553O0dqiGUFnb+W+oe
+KB6SfST0DiqATBJee61kJWw0hzC8EYwDVXgGJnw4c4XqmaAt0JNLPSq8F77DMkC
UQzAdz7U8QxrJp9cwdz4HpWiVXolFJ7I6Gg9Og+KBxAMDIWp/mQNa06Y+b0XQgmW
/KH4/AJMC+cn5GCYq55cSn+ZmKGO3JVB4tbj1VRgyxF/+dBlfiw94YoHxI6ODvF/
440Mo1rtI9P5+hdqGlkqxZmjZBzawCWZDHkos75dKIYl332FqrwubBNngL/St8GO
1DGlK6+STDLIE8XyFPhqKLBiObhnKhnZHjtgmGXEw20ZYx7QLd4IPOLLVGdYFik=
=PWeG
-----END PGP SIGNATURE-----
