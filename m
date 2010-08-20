From: Thomas Mueller <thomas@chaschperli.ch>
Subject: Re: mvsas: blocked task on writing to tape
Date: Fri, 20 Aug 2010 10:40:32 +0200
Message-ID: <4C6E3F80.1010801@chaschperli.ch>
References: <i4jbu0$icb$2@dough.gmane.org> <6B62480106F2B34D8404CF2FDAA4D9EF96D9C4CBFF@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN> <4C6D6CB5.5030806@chaschperli.ch> <alpine.DEB.1.10.1008200845000.8562@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from trillian.muellerit.ch ([83.169.22.129]:35886 "EHLO
	trillian.muellerit.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0HTIki (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Aug 2010 04:40:38 -0400
In-Reply-To: <alpine.DEB.1.10.1008200845000.8562@uplift.swm.pp.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Geetha Gopalan, ERS-HCLTech" <geethagp@hcl.com>

On 20.08.2010 08:47, Mikael Abrahamsson wrote:
 > On Thu, 19 Aug 2010, Thomas Mueller wrote:
 >
 >> see answer 3. i suspect the the SAS card (mvsas) not the drive to be
 >> the problem.
 >
 > Does your card work in other aspects, with drives etc?

the Areca ARC-1300ix-16 card is only for the two tape drives. currently 
no spare SAS/SATA drives to test with.
