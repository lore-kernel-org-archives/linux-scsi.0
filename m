From: Richard Gooch <rgooch@ras.ucalgary.ca>
Subject: Re: /proc/scsi/map
Date: Sat, 15 Jun 2002 09:52:12 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206151552.g5FFqCT14714@vindaloo.ras.ucalgary.ca>
References: <20020615133606.GC11016@gum01m.etpnet.phys.tue.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020615133606.GC11016@gum01m.etpnet.phys.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

Kurt Garloff writes:
> Hi SCSI users,
> 
> from people using SCSI devices, there's one question that turns up again=20
> and again: How can one assign stable device names to SCSI devices in
> case there are devices that may or may not be switched on or connected.
> 
> There are a couple of ways to address this problem:
[...]
> (c) devfs
[...]
> Unfortunately, those approaches all have some deficiencies.
[...]
> Ad (c): devfs is currently not (yet?) an option for distributions
>         due to security and stability considerations.

Mandrake is using devfs. And the security and stability issues have
been fixed many months ago. The "devfs races" that Al used to complain
about regularly have been fixed. I haven't heard from Al for many
months (I see that as a positive sign:-). The current devfs code is in
maintenance mode. The next release of code will be a new devfs core
which uses the VFS for tree maintenance, making the code much smaller.
I.e. not a bugfixing release.

If there *are* remaining bugs with the devfs core (or devfsd for that
matter), I've not been made aware of them. If you know something I
don't, please let me know. AFAICT, all the bugs are long since solved.

				Regards,

					Richard....
Permanent: rgooch@atnf.csiro.au
Current:   rgooch@ras.ucalgary.ca
