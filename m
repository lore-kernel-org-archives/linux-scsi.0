From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 5/6] [SCSI] Look up and store NAA if VPD page 0x83 is
 present
Date: Thu, 17 Jul 2014 13:48:01 +0200
Message-ID: <53C7B7F1.2060005@acm.org>
References: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com> <1401335565-29865-6-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf2.bxl.stone.is ([5.134.1.239]:49518 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868AbaGQLsP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2014 07:48:15 -0400
In-Reply-To: <1401335565-29865-6-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

On 05/29/14 05:52, Martin K. Petersen wrote:
> Copy offloading requires us to know the NAA descriptor for both source
> target device. This descriptor is mandatory in the Device Identification
> VPD page. Locate this descriptor in the returned VPD data so we don't
> have to do lookups for every copy command.

Hello Martin,

Sorry for the late reply but it's only now that I noticed this patch.
Are you sure that presence of a NAA descriptor is mandatory ? This is
what I found in SPC-4 r37 paragraph 7.8.6.2.1:

<quote>
At least one designation descriptor should have the DESIGNATOR TYPE
field set to:
a) 2h (i.e., EUI-64-based);
b) 3h (i.e., NAA); or
c) 8h (i.e., SCSI name string).
</quote>

I think this means that presence of one of these three types of
descriptors is sufficient in order to be compliant with SPC-4.

Thanks,

Bart.

