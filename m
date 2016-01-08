From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: System "hangs" on kernels > v4.4-rc1 - mpt2sas problem?
Date: Fri, 08 Jan 2016 12:28:03 -0500
Message-ID: <yq1r3hsf0bg.fsf@sermon.lab.mkp.net>
References: <3908561D78D1C84285E8C5FCA982C28F39FA658E@ORSMSX114.amr.corp.intel.com>
	<yq137u8iyue.fsf@sermon.lab.mkp.net>
	<3908561D78D1C84285E8C5FCA982C28F39FA727F@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F39FA727F@ORSMSX114.amr.corp.intel.com>
	(Tony Luck's message of "Fri, 8 Jan 2016 16:55:52 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Luck," == Luck, Tony <tony.luck@intel.com> writes:

Luck,> I also see that mpt2 and mpt3 were merged, with mpt2 option still
Luck,> there as a legacy driver.  Which should I be using?

If you previously had MPT2SAS enabled in your .config then the new
kernel should automatically pull MPT3SAS in. You still need to verify in
your initrd that the mpt3sas.ko module gets included, though. How that
works depends on your distro.

-- 
Martin K. Petersen	Oracle Linux Engineering
