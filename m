From: jim owens <jowens@hp.com>
Subject: Re: thin provisioned LUN support
Date: Thu, 06 Nov 2008 10:57:25 -0500
Message-ID: <491313E5.6060505@hp.com>
References: <4913028B.6010405@redhat.com> <49130CF2.6010403@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:17865 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbYKFP53 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 10:57:29 -0500
In-Reply-To: <49130CF2.6010403@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>

James Bottomley wrote:

> By the way, the latest (from 2 days ago) version of the Thin
> Provisioning proposal is here:
> 
> http://www.t10.org/ftp/t10/document.08/08-149r4.pdf

If I understand the spec [ not likely ;) ] ...

jim owens wrote:

 > And the vendors need to provide the device trim chunk size in
 > a standard way (like scsi geometry) to the filesystem.

It may be that the READ CAPACITY (16) provides the trim chunk
size via the "logical blocks per physical block exponent".

But since this is just a T10 spec, I would want that
interpretation verified by the array vendors.

jim
