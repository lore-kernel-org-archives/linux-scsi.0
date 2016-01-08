From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: System "hangs" on kernels > v4.4-rc1 - mpt2sas problem?
Date: Fri, 8 Jan 2016 17:29:42 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F39FA73D2@ORSMSX114.amr.corp.intel.com>
References: <3908561D78D1C84285E8C5FCA982C28F39FA658E@ORSMSX114.amr.corp.intel.com>
	<yq137u8iyue.fsf@sermon.lab.mkp.net>
	<3908561D78D1C84285E8C5FCA982C28F39FA6C38@ORSMSX114.amr.corp.intel.com>
 <yq1vb74f0g5.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1vb74f0g5.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> Well, you definitely have a SAS2308 installed. The question is whether
> that's the only controller or not. Your bisect aimed at a megaraid_sas
> patch. I just want to make sure we're looking at the right set of
> commits.

I confused you with my e-mail ... that megaraid commit wasn't the final
output of bisect (I've not succeeded in pinning this to a specific commit
in any bisection yet). It was just one of the bad boots.

> So if you could boot an older kernel and verify that your root fs is
> indeed on a disk attached to the mpt2sas controller that would be
> helpful.

All (both) my disks are on this one and only controller. So, yes - my
root filesystem is there.

-Tony
