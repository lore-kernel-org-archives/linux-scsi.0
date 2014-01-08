From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Tue, 07 Jan 2014 20:16:19 -0500
Message-ID: <52CCA6E3.2090400@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com> <1387236657-4852-1-git-send-email-psusi@ubuntu.com> <52CA1191.8060804@ubuntu.com> <52CA5CF4.2080708@codeaurora.org> <52CA744F.2080609@intel.com> <52CAC067.20601@ubuntu.com> <52CBB188.2080707@intel.com> <52CC1422.1020101@ubuntu.com> <52CCA3CF.5050308@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52CCA3CF.5050308@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 01/07/2014 08:03 PM, Aaron Lu wrote:
> You mean you want to leave the disk runtime suspended after a
> system resume and in the meantime make sure the disk is indeed not
> spun up?

Yep.  If it is spun up, then the runtime status should be updated to
reflect that, otherwise it tricks user space programs into avoiding
doing IO to the disk for fear of waking it, and prevents the runtime
autosuspend timer from kicking in.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSzKbjAAoJEI5FoCIzSKrwhEsH/3WXEJm2+uPR2zIeGVvZ/I2X
yu0KpcMto0Ox/v2htII/SjQsmhAPbyphTcbJeZJTmbA5EZmNixZXrZAS1vy3vK06
n2Azmywuf0mihfZV1ORg1GuwjgqSSW9MNRw+IuJ7NkxtOZWvWFRNvpcVdyfcig6d
26CP0drDH/j9VL5L1UFWensESswAWV9l1Ht45FUemQw5QDQK6hwUpOAfhbnurz06
OCOs4QRC+O/zWyxzMVKQtQnCEd5tRnKQq0K6d2ZmCKe368KNUrKZ+sk3SPabYtjI
3CEv1+ytG8VajzxJ0cj4TuePK2O+lcd0TWddARJqxZg7o/JYWAyN4yMFoPsAUPo=
=oDcD
-----END PGP SIGNATURE-----
