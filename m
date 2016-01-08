From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: System "hangs" on kernels > v4.4-rc1 - mpt2sas problem?
Date: Thu, 07 Jan 2016 21:34:01 -0500
Message-ID: <yq137u8iyue.fsf@sermon.lab.mkp.net>
References: <3908561D78D1C84285E8C5FCA982C28F39FA658E@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F39FA658E@ORSMSX114.amr.corp.intel.com>
	(Tony Luck's message of "Thu, 7 Jan 2016 22:55:50 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tony" == Luck, Tony <tony.luck@intel.com> writes:

Tony,

Tony> This one has been hard for me to bisect. Partly because it just
Tony> takes so long to reboot the servers that have the problem, but
Tony> also because there may be more than one thing going on.  One thing
Tony> that seems pretty certain is that things are OK prior to:

We consolidated the mpt2sas and mpt3sas drivers in 4.4. I can see the
driver getting loaded (and failing to allocate memory for some reason)
in your first log but it's absent in the second.

Tony>     megaraid_sas: Increase timeout to 60 secs for abort frames
Tony> during shutdown

megaraid_sas is an entirely different beast from mpt[23]sas. Please let
us know which type of controller your disks are hanging off of.

-- 
Martin K. Petersen	Oracle Linux Engineering
