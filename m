From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: System "hangs" on kernels > v4.4-rc1 - mpt2sas problem?
Date: Fri, 8 Jan 2016 18:23:46 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F39FA77D9@ORSMSX114.amr.corp.intel.com>
References: <3908561D78D1C84285E8C5FCA982C28F39FA658E@ORSMSX114.amr.corp.intel.com>
	<yq137u8iyue.fsf@sermon.lab.mkp.net>
	<3908561D78D1C84285E8C5FCA982C28F39FA727F@ORSMSX114.amr.corp.intel.com>
	<yq1r3hsf0bg.fsf@sermon.lab.mkp.net>
	<3908561D78D1C84285E8C5FCA982C28F39FA73FD@ORSMSX114.amr.corp.intel.com>
 <yq1io34ezoh.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1io34ezoh.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> Tony> /me goes to find how to tell Dracut to add the mpt3sas module to
> Tony> the initrd.
>
> Great!

/etc/dracut.conf
add_drivers+="mpt3sas"

and now my system boots.

Thanks again for the help.

-Tony
