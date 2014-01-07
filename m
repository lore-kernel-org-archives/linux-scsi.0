From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Tue, 07 Jan 2014 10:43:28 -0500
Message-ID: <52CC20A0.7060606@ubuntu.com>
References: <Pine.LNX.4.44L0.1401071021100.1296-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1401071021100.1296-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lu@intel.com>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/7/2014 10:25 AM, Alan Stern wrote:
> This doesn't seem like a good idea.  The way to speed up resumes is
> to allow sd's resume routine to return while the disk is still
> spinning up (i.e., make the spin-up asynchronous).  There already
> have been patches submitted to do this; I don't know what happened
> to them.

Sure, if that is your *only* goal.  I also want the disk to not spin
up *at all* if possible.  There's no sense spinning up all of your
disks every time you resume when you very rarely access some of them.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSzCCgAAoJEI5FoCIzSKrwkMAH/3Fs/1tdkCUNtj32PjvD/C2O
qgJwkXKtJmThL9+8NK5lNLxWt+buJ9HBozoeKs2AkBIsRpxdXZb6FnutQHhOSIBQ
vqgwKoGvKQUc7bj0sg2WUVckYkZcl2hs54PIZgaAj8VwcJZE7XTNo+BeGlyslyi+
isG+BvGInBkhJ7BsR0nC05Sytrb6F6xYkOkV5hn2PjvPNhxpw9dKlVLGfO9qNFcJ
irazJwVQ2k49y7IGHS+K0NLGv45pBEPRcirwTaxfH0IIVCmDPeQk86SmpmeS+TSO
o3tFgUC7JQjeH2yg0YXkIEGZGGycv57H7Gf+hAOL9mOOD3CD0D4TagbMZP2SOIU=
=gM81
-----END PGP SIGNATURE-----
