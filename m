From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Enterprise workload testing for storage and filesystems
Date: Thu, 20 Nov 2008 16:37:05 -0500
Message-ID: <x49y6zegjum.fsf@segfault.boston.devel.redhat.com>
References: <1226962063.3403.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33548 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbYKTVhK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2008 16:37:10 -0500
In-Reply-To: <1226962063.3403.13.camel@localhost.localdomain> (James
	Bottomley's message of "Tue, 18 Nov 2008 07:47:42 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, "K.S. Bhaskar" <ks.bhaskar@fnis.com>

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> Hi all,
>
> High on our list at the recent Linux Foundation end user summit was
> obtaining a method of obtaining enterprise workloads (or simulators) we
> can run in our own testing environments.  The main problem being that
> the data sets used by the systems are usually secret or under regulatory
> embargo and thus unobtainable.  However, several participants noted that
> regulatory prohibitions also extended to their own in-house IT team,
> thus they had had to develop simulators for the workloads which, since
> they contained no customer data, might be more widely distributable.
>
> Fidelity National Information Service were the first to try this.
> They've kicked off a sourceforge site for their stress testing tool
> (which is the same tool they use in their own qualification labs).  The
> source for the tool is available here:
>
> http://sourceforge.net/project/showfiles.php?group_id=11026&package_id=298597
>
> And it comes with a fairly detailed readme explaining what it's trying
> to simulate and why.  Hopefully this will give us all a much better
> insight into both enterprise workloads and the way enterprise IT
> departments conduct testing.
>
> Let's see how our storage and filesystem tuning measures up to this.

This is indeed great news!  The tool is very flexible, so I'd like to
know if we can get some sane configuration options to start testing.
I'm sure I can cook something up, but I'd like to be confident that what
I'm testing does indeed reflect a real-world workload.

Cheers,
Jeff
