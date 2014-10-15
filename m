From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 2/3] scsi: add try_rc16 blacklist flag
Date: Wed, 15 Oct 2014 02:07:21 +0000
Message-ID: <30375c9b3e144580b4b98cf71f64e5b0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20141010074901.GA32028@sucs.org>
	<20141010075251.GC32028@sucs.org> <yq1mw8y6sxf.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1mw8y6sxf.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Tuesday, October 14, 2014 6:08 PM
> To: Sitsofe Wheeler
> Cc: KY Srinivasan; Haiyang Zhang; Christoph Hellwig; Hannes Reinecke; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; James E.J. Bottomley
> Subject: Re: [PATCH 2/3] scsi: add try_rc16 blacklist flag
> 
> >>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:
> 
> Sitsofe> Microsoft Hyper-V virtual disks currently only claim SPC-2
> Sitsofe> compliance causing the kernel skip checks for features such as
> Sitsofe> thin provisioning even though the virtual disk advertises them.
> 
> Last time around we identified this as a problem with Microsoft's
> interpretation of the T10 SBC spec. And they promised that they are going to
> fix that.

It has been fixed in windows 10 and a bug has been opened for earlier hosts.

K. Y
> 
> --
> Martin K. Petersen	Oracle Linux Engineering
