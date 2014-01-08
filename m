From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Wed, 08 Jan 2014 14:30:48 -0500
Message-ID: <52CDA768.4080304@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com> <1387236657-4852-1-git-send-email-psusi@ubuntu.com> <52CA1191.8060804@ubuntu.com> <52CA5CF4.2080708@codeaurora.org> <52CA744F.2080609@intel.com> <52CAC067.20601@ubuntu.com> <52CBB188.2080707@intel.com> <52CC1422.1020101@ubuntu.com> <52CCA3CF.5050308@intel.com> <52CCA6E3.2090400@ubuntu.com> <52CCAAA7.4070104@intel.com> <52CCAF8C.7040407@ubuntu.com> <52CCB3E8.5010101@intel.com> <52CCB5C4.7020206@ubuntu.com> <52CCB99A.4090201@intel.com> <52CCE11A.3040609@ubuntu.com> <52CCF775.3010303@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52CCF775.3010303@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/8/2014 2:00 AM, Aaron Lu wrote:
> Then I would say we just keep the pm_request_resume call in their
> system resume callback. For drives that have that cool feature
> turned on, it will be in runtime active state while it's actually
> in standby mode, not

No, it won't since the runtime resume starts the drive.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSzadoAAoJEI5FoCIzSKrwQWsIAKt/F+eiYYrxxjx58hFCwLxV
3E+CDiuf+pTyUUqPFgcGjyNrfoBO2nWXiCyg5XZ//pjPwbD4GenwSajgUIvKRw/6
0mDw4bb4CyU9/vqVKwHUHfM2jgsAuK9VFn+1fSomODy6B9ZYX6pDPr3jw5S7kDko
nDaYhBX9L2/AE4oPo2qPLpAPMxiYFD9qIi8LcfW/Ha2Av7AneIyTXEvFZzyeDv2K
WoH/KF59snFz9t4wwwfdqu1l1w93b+Tcn2zCpFBaA63TyrJKq4qpx9/W+INgBGol
HKEyv1vh5UkaVSvffiFE/2b1lR4n0hL7LVMe1egazAlNPcsjXdBZv1amYJ7NltI=
=N8WO
-----END PGP SIGNATURE-----
