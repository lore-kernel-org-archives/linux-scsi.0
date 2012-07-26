From: Robert Trace <tachyon@farcaster.org>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Thu, 26 Jul 2012 15:20:30 -0400
Message-ID: <5011987E.6020207@farcaster.org>
References: <4FFB32E5.1050109@farcaster.org> <4FFB7354.8040809@matthiasprager.de> <4FFB8A86.7000009@farcaster.org> <4FFCBA4C.4000502@farcaster.org> <4FFD6F3D.2030708@matthiasprager.de> <4FFD8410.7050604@matthiasprager.de> <20120717180932.GB2878@google.com> <5005BF7D.2050703@matthiasprager.de> <20120717200136.GC24336@google.com> <500A9D7C.8080801@matthiasprager.de> <20120722173146.GE5144@dhcp-172-17-108-109.mtv.corp.google.com> <loom.20120726T003312-580@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eris.farcaster.org ([75.127.72.104]:54022 "EHLO
	smtp.farcaster.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab2GZT3L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2012 15:29:11 -0400
In-Reply-To: <loom.20120726T003312-580@post.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tomm <tomm@lime-technology.com>
Cc: linux-scsi@vger.kernel.org

On 07/25/2012 06:35 PM, tomm wrote:
>
> If this is a driver or firmware bug, then why would commit
> 85ef06d1d252f6a2e73b678591ab71caad4667bb 
> cause this to happen?  What is the interaction between this issue
> and this commit which just flushes events?

That's confusing to me as well.  Tejun's patch seems very unrelated to
anything related to power-state on non-removable disks.

> Also this issue does not happen with mvsas, only with mpt2sas.

Now _that_ is a useful data point.  Is that with SATA disks attached?
Why is it limited (so far) to just the mpt2sas controller?

-- Robert

