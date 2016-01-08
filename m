From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: System "hangs" on kernels > v4.4-rc1 - mpt2sas problem?
Date: Fri, 8 Jan 2016 16:55:52 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F39FA727F@ORSMSX114.amr.corp.intel.com>
References: <3908561D78D1C84285E8C5FCA982C28F39FA658E@ORSMSX114.amr.corp.intel.com>
 <yq137u8iyue.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

I also see that mpt2 and mpt3 were merged, with mpt2 option still there
as a legacy driver.  Which should I be using?   My config file has these
MPT settings:

$ grep MPT .config
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS=m

-Tony
