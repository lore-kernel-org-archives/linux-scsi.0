From: Robert Trace <maillist@farcaster.org>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Thu, 26 Jul 2012 15:16:43 -0400
Message-ID: <5011979B.9020507@farcaster.org>
References: <4FFB8A86.7000009@farcaster.org>  <4FFCBA4C.4000502@farcaster.org> <4FFD6F3D.2030708@matthiasprager.de>  <4FFD8410.7050604@matthiasprager.de> <20120717180932.GB2878@google.com>  <5005BF7D.2050703@matthiasprager.de> <20120717200136.GC24336@google.com>  <500A9D7C.8080801@matthiasprager.de>  <20120722173146.GE5144@dhcp-172-17-108-109.mtv.corp.google.com>  <1343225953.12094.55.camel@dabdike> <20120725171723.GB32378@google.com> <1343246155.12094.59.camel@dabdike> <501087C1.2020209@matthiasprager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eris.farcaster.org ([75.127.72.104]:53985 "EHLO
	smtp.farcaster.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab2GZTQv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2012 15:16:51 -0400
In-Reply-To: <501087C1.2020209@matthiasprager.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Prager <linux@matthiasprager.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>, Eric Moore <Eric.Moore@lsi.com>, Alan <alan@lxorguk.ukuu.org.uk>, "Darrick J. Wong" <djwong@us.ibm.com>, linux-ide@vger.kernel.org

On 07/25/2012 07:56 PM, Matthias Prager wrote:
> 
> I don't yet understand all the code but I'm following your discussion
> with Tejun: I've set up a minimal vm running gentoo with a mpt2sas
> driven controller in passthrough mode. I've applied your proposed patch
> against the vanilla 3.5.0 kernel (which includes Tejun's commit), and
> I'm happy to report the problem does seem to get fixed by it.

I can confirm this on my hardware as well with both 3.4.4 and 3.5.0.
Without James' patch the kernels will immediately drop the I/O and with
the patch both kernels will wake the SATA disks and then complete the
I/O successfully.

-- Robert
