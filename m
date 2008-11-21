From: Grant Grundler <grundler@google.com>
Subject: Re: Enterprise workload testing for storage and filesystems
Date: Thu, 20 Nov 2008 20:42:29 -0800
Message-ID: <da824cf30811202042p43549a1bne0eefa627424be33@mail.gmail.com>
References: <1226962063.3403.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:9019 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbYKUEmd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2008 23:42:33 -0500
Received: from zps19.corp.google.com (zps19.corp.google.com [172.25.146.19])
	by smtp-out.google.com with ESMTP id mAL4gVi9002949
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2008 20:42:31 -0800
Received: from fg-out-1718.google.com (fgae21.prod.google.com [10.86.56.21])
	by zps19.corp.google.com with ESMTP id mAL4gQbo001794
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2008 20:42:30 -0800
Received: by fg-out-1718.google.com with SMTP id e21so586427fga.37
        for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2008 20:42:29 -0800 (PST)
In-Reply-To: <1226962063.3403.13.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, "K.S. Bhaskar" <ks.bhaskar@fnis.com>

On Mon, Nov 17, 2008 at 2:47 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
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

Google has the same concerns. Hoping to work through those, last year
I arranged funding for UNSW (Joshua Root) to develop a GPL linux block
layer replay tool:
    http://www.gelato.unsw.edu.au/IA64wiki/JoshuaRoot/MarkovChains

Unfortunately, I've not been able to address all concerns with this
and thus can't offer any google specific markov chains. :( Still I
hope this tool can be of use to others.


> Fidelity National Information Service were the first to try this.
> They've kicked off a sourceforge site for their stress testing tool
> (which is the same tool they use in their own qualification labs).  The
> source for the tool is available here:
>
> http://sourceforge.net/project/showfiles.php?group_id=11026&package_id=298597

Awesome! Kudos!

> And it comes with a fairly detailed readme explaining what it's trying
> to simulate and why.  Hopefully this will give us all a much better
> insight into both enterprise workloads and the way enterprise IT
> departments conduct testing.
>
> Let's see how our storage and filesystem tuning measures up to this.

*nod*

thanks,
grant
