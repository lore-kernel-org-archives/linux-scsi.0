From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: System "hangs" on kernels > v4.4-rc1 - mpt2sas problem?
Date: Fri, 08 Jan 2016 12:25:14 -0500
Message-ID: <yq1vb74f0g5.fsf@sermon.lab.mkp.net>
References: <3908561D78D1C84285E8C5FCA982C28F39FA658E@ORSMSX114.amr.corp.intel.com>
	<yq137u8iyue.fsf@sermon.lab.mkp.net>
	<3908561D78D1C84285E8C5FCA982C28F39FA6C38@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F39FA6C38@ORSMSX114.amr.corp.intel.com>
	(Tony Luck's message of "Fri, 8 Jan 2016 05:01:16 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tony" == Luck, Tony <tony.luck@intel.com> writes:

Tony> If you need something more, let me know what commands to run.

Well, you definitely have a SAS2308 installed. The question is whether
that's the only controller or not. Your bisect aimed at a megaraid_sas
patch. I just want to make sure we're looking at the right set of
commits.

So if you could boot an older kernel and verify that your root fs is
indeed on a disk attached to the mpt2sas controller that would be
helpful.

-- 
Martin K. Petersen	Oracle Linux Engineering
