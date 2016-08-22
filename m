From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 5/5] nvme-fabrics: Add FC LLDD loopback driver to test FC
 host and target transport
Date: Mon, 22 Aug 2016 10:29:38 -0700
Message-ID: <de5d47f0-3d47-8004-19ed-0cb2f39c9aa3@broadcom.com>
References: <5792b91f.Lb5BdNQrSWnmgOYG%james.smart@broadcom.com>
 <20160811212336.GH18013@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34537 "EHLO
        mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755749AbcHVR3l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2016 13:29:41 -0400
Received: by mail-pa0-f51.google.com with SMTP id fi15so39557543pac.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2016 10:29:40 -0700 (PDT)
In-Reply-To: <20160811212336.GH18013@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org



On 8/11/2016 2:23 PM, Christoph Hellwig wrote:
> On Fri, Jul 22, 2016 at 05:23:59PM -0700, James Smart wrote:
>> Add FC LLDD loopback driver to test FC host and target transport within
>> nvme-fabrics
>>
>> To aid in the development and testing of the lower-level api of the FC
>> transport, this loopback driver has been created to act as if it were a
>> FC hba driver supporting both the host interfaces as well as the target
>> interfaces with the nvme FC transport.
> A proper FC loop device should support SCSI and NVMe.  Any chance to
> morph it into one that does both?

Nope. Not really appropriate for this module, whose goals were to test 
the fc-nvme interfaces. SCSI is a whole different beast.

-- james

