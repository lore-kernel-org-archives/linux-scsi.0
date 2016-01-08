From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: System "hangs" on kernels > v4.4-rc1 - mpt2sas problem?
Date: Fri, 08 Jan 2016 12:41:50 -0500
Message-ID: <yq1io34ezoh.fsf@sermon.lab.mkp.net>
References: <3908561D78D1C84285E8C5FCA982C28F39FA658E@ORSMSX114.amr.corp.intel.com>
	<yq137u8iyue.fsf@sermon.lab.mkp.net>
	<3908561D78D1C84285E8C5FCA982C28F39FA727F@ORSMSX114.amr.corp.intel.com>
	<yq1r3hsf0bg.fsf@sermon.lab.mkp.net>
	<3908561D78D1C84285E8C5FCA982C28F39FA73FD@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F39FA73FD@ORSMSX114.amr.corp.intel.com>
	(Tony Luck's message of "Fri, 8 Jan 2016 17:32:50 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tony" == Luck, Tony <tony.luck@intel.com> writes:

Tony> The failure mode is very, very odd though. Shouldn't I have got a
Tony> "can't mount root" error?

The init stuff can be pretty patient when it comes to waiting for the
root disk to materialize. It's conceivable that you would have gotten an
error if you had waited long enough.

Tony> /me goes to find how to tell Dracut to add the mpt3sas module to
Tony> the initrd.

Great!

-- 
Martin K. Petersen	Oracle Linux Engineering
