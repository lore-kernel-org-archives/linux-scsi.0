From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [LSF/MM TOPIC] Making sure soft SCSI Targets are Valid
Date: Mon, 04 Feb 2013 21:38:37 -0800
Message-ID: <1360042717.22598.76.camel@haakon2.linux-iscsi.org>
References: <51081F68.1030808@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52605 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3BEFij (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2013 00:38:39 -0500
In-Reply-To: <51081F68.1030808@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org, ronnie sahlberg <ronniesahlberg@gmail.com>

On Tue, 2013-01-29 at 11:13 -0800, Lee Duncan wrote:
> Hi:
> 
> I'm not sure if there is much interest in this, but I've recently
> realized that there is no good free software to validate iSCSI targets,
> not to mention FCOE targets, IB soft targets, etc. There's just no way
> to know if any change you make is "legal" short of learning to speak
> SCSI geek spec (or waiting to see what fails when you make a subtle change).
> 
> So I have been working with the (user-space) libiscsi creator and
> maintainer, Ronnie Sahlberg, to enhance his test suite. But this only
> addresses iSCSI targets. Some of his tests have already shown problems
> like kernel panics when an incorrect bit is injected, showing the need
> for such testing.
> 
> It occurs to me it would be most valuable if we had more generic SCSI
> tests, not even limited to soft targets, available to developers and
> manufacturers. How best to support such tests with our SCSI layer, and
> what tests are needed now and in the future may be a good topic for
> discussion.

+1.

Please count me in for this discussion.  There are a number of CDB level
tests that need to be added to scsi-testsuite.git, and I'd really love
to get those interested working on a single codebase for SCSI target
verification.

--nab




