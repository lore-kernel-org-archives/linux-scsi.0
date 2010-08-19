From: Thomas Mueller <thomas@chaschperli.ch>
Subject: Re: mvsas: blocked task on writing to tape
Date: Thu, 19 Aug 2010 19:41:09 +0200
Message-ID: <4C6D6CB5.5030806@chaschperli.ch>
References: <i4jbu0$icb$2@dough.gmane.org> <6B62480106F2B34D8404CF2FDAA4D9EF96D9C4CBFF@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from trillian.muellerit.ch ([83.169.22.129]:46242 "EHLO
	trillian.muellerit.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab0HSRrp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2010 13:47:45 -0400
In-Reply-To: <6B62480106F2B34D8404CF2FDAA4D9EF96D9C4CBFF@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Geetha Gopalan, ERS-HCLTech" <geethagp@hcl.com>

On 19.08.2010 17:40, Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL 
Tech wrote:
 > Hi Thomas,
 > Need below information.
 > 1. Dmesg or /var/log/messages

partial output from dmesg from 2.6.35.2 kernel -> see my last mail. have 
no access to the system anymore today. can provide more tomorrow.

 > 2. Which kernel version you are using?

2.6.32-bpo.4-amd64 (debian pacakge, IMHO 2.6.32.11 with debian patches) 
is OK
2.6.32-bpo.5-amd64 (debian package, IMHO 2.6.32.15 with debian patches) 
is NOT OK
2.6.34-1-amd64 (debian package) is NOT OK
2.6.35.2  (compiled from kernel.org source) is NOT OK

 > 3. Are you running any applications?

as i told i was writing to a tape with btape (Bacula tape test tool, 
btape command "speed file_size=50"). It was writing the 4th file (50gb 
per file) when it stopped working

 > 4. Whether tape drive is discovered or not? As I was working with 
this same drive only. I never faced any problem with this drive.

see answer 3. i suspect the the SAS card (mvsas) not the drive to be the 
problem.

 > 5. Check whether this is working with 2.6.33 kernels or not?

no 2.6.33 kernel handy yet, could compile one tomorrow.

- Thomas
