From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC 1/2] cxlflash: Base support for IBM CXL Flash Adapter
Date: Fri, 15 May 2015 15:58:39 -0500
Message-ID: <95CB3977-7373-463C-9A93-85D98922D612@linux.vnet.ibm.com>
References: <1430110220-13268-1-git-send-email-mrochs@linux.vnet.ibm.com> <20150511090941.GD28820@infradead.org> <660CA342-479E-4DC4-9BC0-880A28760AAC@linux.vnet.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:57987 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161033AbbEOU6q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2015 16:58:46 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 15 May 2015 14:58:45 -0600
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id E95101FF0030
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2015 14:49:52 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t4FKwgv637421144
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2015 13:58:42 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t4FKweuB005733
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2015 14:58:42 -0600
In-Reply-To: <660CA342-479E-4DC4-9BC0-880A28760AAC@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, Michael Neuling <mikey@neuling.org>, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On May 11, 2015, at 11:11 PM, Matthew R. Ochs wrote:
> On May 11, 2015, at 4:09 AM, Christoph Hellwig wrote:
>> 
>> Please drop all the code related to your weird direct access ioctls
>> from this patch.  Without that it looks mostly mergeable.
>> 
> Could you expand more on your objection <to the second patch>? Are you generally opposed to a kernel bypass or is there something specific regarding our implementation to solving the problem (ioctls)?
> 
> One of the key features we were hoping to provide with this driver is a kernel bypass. This device has a very unique MMU interface that allows user applications and hardware to share memory directly. The problem we ran into is how to configure and manage that access. The device is very SCSI-like and since we were implementing a SCSI adapter driver to support filesystem access for traditional use cases, the ioctls seemed to be a reasonable solution.

We're going to proceed with submitting the first patch that contains filesystem access while the discussion continues regarding how best to implement the kernel bypass feature.


-matt
