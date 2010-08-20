From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: mvsas: blocked task on writing to tape
Date: Fri, 20 Aug 2010 08:47:12 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1008200845000.8562@uplift.swm.pp.se>
References: <i4jbu0$icb$2@dough.gmane.org> <6B62480106F2B34D8404CF2FDAA4D9EF96D9C4CBFF@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN> <4C6D6CB5.5030806@chaschperli.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swm.pp.se ([212.247.200.143]:45719 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab0HTGzb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2010 02:55:31 -0400
In-Reply-To: <4C6D6CB5.5030806@chaschperli.ch>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Mueller <thomas@chaschperli.ch>
Cc: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Geetha Gopalan, ERS-HCLTech" <geethagp@hcl.com>

On Thu, 19 Aug 2010, Thomas Mueller wrote:

> see answer 3. i suspect the the SAS card (mvsas) not the drive to be the 
> problem.

Does your card work in other aspects, with drives etc?

I have one card that uses mvsas (AOC-SASLP-MV8) and in my testing the 
mvsas driver is basically unusable in its current state for this card. It 
might work better for your card though...

<http://www.spinics.net/lists/linux-ide/msg35605.html>

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
