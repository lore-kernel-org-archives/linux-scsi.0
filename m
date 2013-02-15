From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] SG_SCSI_RESET ioctl: add no_escalate values
Date: Fri, 15 Feb 2013 13:46:11 -0600
Message-ID: <511E9083.3090004@tributary.com>
References: <511E8EF7.3010004@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.58]:58621 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3BOTqO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Feb 2013 14:46:14 -0500
In-Reply-To: <511E8EF7.3010004@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/15/2013 1:39 PM, Douglas Gilbert wrote:
> Further to the thread titled: "[PATCH] SG_SCSI_RESET ioctl should only
> perform requested operation" by Jeremy Linton a patch is presented that
> adds "no_escalate" versions to the existing ioctl. This should not break
> any existing code.

	Looks good, I will apply it here and try it out.



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRHpCDAAoJEL5i86xrzcy7lvoIAK5pxe8rdx8WinxG/NqhLkRb
+537Ln3asshkWcH385gaa1JzizoWhiS1+H+tGcLdEwPDwvSSGGqtUAn/qtxB64cM
F5X0XqjS/XVup7GrkcoQ4ZzXG2rdI6Lb5gwbpb98QeCGzaVKfRMvJCCtXSIFuPXA
S7gL0Xl5d5KapPCWVRpucE05XVaAZq2vrxC3/8hDwB8+3HYUW4gUTcwSAM0pvcUb
d7w984jlcFHVxT3Yk+ZHuQ3QOKifbqWBE9WlsgqkPnGjlAK8Q19NQsD6/C9Q9wTg
OhMjj9HKHOlcBE65e/xKlcncTXjaa1qcLfa94hOukjSQBkf0vqJH3XeWuACESE0=
=Oqr2
-----END PGP SIGNATURE-----
