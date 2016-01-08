From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: System "hangs" on kernels > v4.4-rc1 - mpt2sas problem?
Date: Fri, 08 Jan 2016 13:40:40 -0500
Message-ID: <yq1y4bzewyf.fsf@sermon.lab.mkp.net>
References: <3908561D78D1C84285E8C5FCA982C28F39FA658E@ORSMSX114.amr.corp.intel.com>
	<yq137u8iyue.fsf@sermon.lab.mkp.net>
	<3908561D78D1C84285E8C5FCA982C28F39FA727F@ORSMSX114.amr.corp.intel.com>
	<yq1r3hsf0bg.fsf@sermon.lab.mkp.net>
	<3908561D78D1C84285E8C5FCA982C28F39FA73FD@ORSMSX114.amr.corp.intel.com>
	<yq1io34ezoh.fsf@sermon.lab.mkp.net>
	<3908561D78D1C84285E8C5FCA982C28F39FA77D9@ORSMSX114.amr.corp.intel.com>
	<1452277927.2297.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452277927.2297.2.camel@HansenPartnership.com> (James
	Bottomley's message of "Fri, 08 Jan 2016 10:32:07 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> We're not quite out of the woods yet: dracut should have seen
James> this automatically because of the module alias bindings.  Is your
James> system somehow unusual and you don't expect the initrd automatic
James> module selection to work?  If not, could you help us debug why it
James> didn't?

Depends how old dracut is. Older versions do not resolve module aliases.

-- 
Martin K. Petersen	Oracle Linux Engineering
