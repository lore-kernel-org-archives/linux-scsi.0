From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH 5/5] Make SCSI SG v4 driver enabled by default and remove
 EXPERIMENTAL dependency, since udev depends on BSG.
Date: Tue, 14 Jul 2009 09:16:50 -0400
Message-ID: <19036.34114.63402.97190@stoffel.org>
References: <1247513973-24899-1-git-send-email-john@stoffel.org>
	<19035.36432.181354.977939@stoffel.org>
	<4A5C27D4.5040204@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mycroft.westnet.com ([216.187.52.7]:59616 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbZGNNRw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2009 09:17:52 -0400
In-Reply-To: <4A5C27D4.5040204@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: John Stoffel <john@stoffel.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org

>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:

Boaz> I would like it if you'd also CC stable@kernel.org on this
Boaz> patch. As this condition is already true for distros in the
Boaz> field.

I can resend it with that CC, no problem.  It's a good experience to
learn git and how to use it properly.

Boaz> [Though distros have enabled it for years and every one is using
Boaz>  the distro's .config when compiling their own Kernel, right?]

Umm, no.  My main machine for the past six or seven years is Debian
based, and came from the 2.4 era of kernels and has been patched and
upgraded for years by hand.  Lots of 'atp-get update'.  Whcih works
well.  So I've also compiled my own kernels.

The real reason for this patch was finally figuring out that Udev
really really really wants this turned on, but doesn't mention it in
any of it's documentation.  So I'm working to update both sides, and
have UDEV mention that it needs this feature, and making the kernel
turn it on by default too.

I'll resend the patch in a few.

John
