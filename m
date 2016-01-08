From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: System "hangs" on kernels > v4.4-rc1 - mpt2sas problem?
Date: Fri, 8 Jan 2016 18:55:57 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F39FA78A3@ORSMSX114.amr.corp.intel.com>
References: <3908561D78D1C84285E8C5FCA982C28F39FA658E@ORSMSX114.amr.corp.intel.com>
	<yq137u8iyue.fsf@sermon.lab.mkp.net>
	<3908561D78D1C84285E8C5FCA982C28F39FA727F@ORSMSX114.amr.corp.intel.com>
	<yq1r3hsf0bg.fsf@sermon.lab.mkp.net>
	<3908561D78D1C84285E8C5FCA982C28F39FA73FD@ORSMSX114.amr.corp.intel.com>
	<yq1io34ezoh.fsf@sermon.lab.mkp.net>
	<3908561D78D1C84285E8C5FCA982C28F39FA77D9@ORSMSX114.amr.corp.intel.com>
	<1452277927.2297.2.camel@HansenPartnership.com>
 <yq1y4bzewyf.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1y4bzewyf.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> Depends how old dracut is. Older versions do not resolve module aliases.

On SLES12-SP1
$ dracut --version
getopt: unrecognized option '--version'
Usage: /usr/bin/dracut [OPTION]... [<initramfs> [<kernel-version>]]

Version: 037-66.2

On RHEL 7.2
$ dracut --version
getopt: unrecognized option '--version'
Usage: /usr/bin/dracut [OPTION]... [<initramfs> [<kernel-version>]]

Version: 033-359.el7

-Tony
