From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC 1/2] cxlflash: Base support for IBM CXL Flash Adapter
Date: Mon, 11 May 2015 23:11:56 -0500
Message-ID: <660CA342-479E-4DC4-9BC0-880A28760AAC@linux.vnet.ibm.com>
References: <1430110220-13268-1-git-send-email-mrochs@linux.vnet.ibm.com> <20150511090941.GD28820@infradead.org>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:33053 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbbELEMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2015 00:12:51 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 12 May 2015 00:12:50 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 01CA438C8026
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 00:12:49 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t4C4Cmx356557572
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 04:12:48 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t4C4ClVT020556
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 00:12:48 -0400
In-Reply-To: <20150511090941.GD28820@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, Michael Neuling <mikey@neuling.org>, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Hi Christoph,

Thank you for looking at this RFC.

On May 11, 2015, at 4:09 AM, Christoph Hellwig wrote:

> On Sun, Apr 26, 2015 at 11:50:20PM -0500, Matthew R. Ochs wrote:
>> SCSI device driver to support filesystem access on the IBM CXL Flash adapter.
> 
> Please drop all the code related to your weird direct access ioctls
> from this patch.  Without that it looks mostly mergeable.
> 

Could you expand more on your objection <to the second patch>? Are you generally opposed to a kernel bypass or is there something specific regarding our implementation to solving the problem (ioctls)?

One of the key features we were hoping to provide with this driver is a kernel bypass. This device has a very unique MMU interface that allows user applications and hardware to share memory directly. The problem we ran into is how to configure and manage that access. The device is very SCSI-like and since we were implementing a SCSI adapter driver to support filesystem access for traditional use cases, the ioctls seemed to be a reasonable solution.


-matt
