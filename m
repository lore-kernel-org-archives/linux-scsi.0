From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Tue, 21 Jan 2014 11:18:34 -0500
Message-ID: <52DE9DDA.9010406@ubuntu.com>
References: <Pine.LNX.4.44L0.1401211049160.1272-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:37889 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaAUQSl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jan 2014 11:18:41 -0500
In-Reply-To: <Pine.LNX.4.44L0.1401211049160.1272-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dan Williams <dan.j.williams@intel.com>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/21/2014 11:03 AM, Alan Stern wrote:
> However, there is a compromise.  The user gets to select the 
> autosuspend delay.  If that delay is set to a very large value, it
> will effectively prevent autosuspends from occurring, without
> causing an already-suspended device to resume right away.  (On the
> other hand, it would not prevent a lazy resume.)

Right, so why can't you set the delay to -1 without waking the already
sleeping drive up?  There are separate sysfs knobs for the delay and
whether or not it is enabled, yet the kernel seems to couple the two
together.



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS3p3aAAoJEI5FoCIzSKrwOx0H/1FgsoJrBhP1gos0/uAX1Tdw
PCiuiq78g7Ej0nF8rGezG++2fWjmkVJRh1L1wooMfggejVa2h5kZLIf/IIakrR4F
h98Y62I9D2R0xdLwEs3+kajonNjJtDejV8TDvMJO/MOv/Afoxjyde8CpDPbZCCiX
MS8fsXAkkIZwlppCk5BzfRaum7JSTOzwfNee65XuvvLJsELCidSDUpMMrc/fYcD1
DuB75b7jEP99Uo5/rGyId5ZM3VEPLLC5mXT3GzEzKd+l9fg4j+7q2fxwA+B62mn4
z62SA5PlT6ZhboH3GhsrSWX1i3Kvuo6PEUUdUyCJYmdwoDUrkDTwuzJ3pQH8BXI=
=91ci
-----END PGP SIGNATURE-----
