From: Michel Meyers <steltek@tcnnet.com>
Subject: Re: [PATCH 1/1] scsi: add Synology DSM 6.0 and higher to 1024 sector
 blacklist
Date: Tue, 12 Apr 2016 10:28:56 +0200
Message-ID: <570CB1C8.5050106@tcnnet.com>
References: <20160114003437.354D28EE1D4@bedivere.hansenpartnership.com>
 <570B63B8.6080104@tcnnet.com> <yq1oa9fzhyi.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smail.vo.lu ([80.90.45.96]:64914 "EHLO smail.vo.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167AbcDLI3Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2016 04:29:25 -0400
In-Reply-To: <yq1oa9fzhyi.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <mchristi@redhat.com>

On 2016-04-12 4:20, Martin K. Petersen wrote:
>>>>>> "Michel" == Michel Meyers <steltek@tcnnet.com> writes:
> 
> Michel> SYNOLOGY iSCSI devices do not work with large I/O and SYNOLOGY
> Michel> changed the identifier of the devices
> 
> Shouldn't we just quirk SYNOLOGY, then?

Could be worth it. As far as I can see, they manufacture no directly
attached drives (only NAS devices, which I presume are all affected by
the same problem as mine).

--
Michel Meyers

