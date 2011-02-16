From: David Milburn <dmilburn@redhat.com>
Subject: Re: [RFC PATCH 2/6] isci: task (libsas interface support)
Date: Wed, 16 Feb 2011 13:35:16 -0600
Message-ID: <4D5C26F4.6060704@redhat.com>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>	<20110207003445.27040.67152.stgit@localhost6.localdomain6>	<4D52AC5A.7020206@redhat.com> <AANLkTinfhEO2uXW94S9q++D8dNjBpOy1_3s64X=ScbLY@mail.gmail.com> <4D5C1BF4.2050100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab1BPTfS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 14:35:18 -0500
In-Reply-To: <4D5C1BF4.2050100@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: David Milburn <dmilburn@redhat.com>, james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

David Milburn wrote:
> Dan Williams wrote:
>> Thanks David, comments below.

> 
> isci_task_abort_task()
> {
>     isci_task_build_tmf(TMF_ABORT_TASK)

Sorry, I meant to say TMF_ABORT_TASK_SET for
isci_task_abort_task_set().

David

>     isci_task_execute_tmf()
> }
> 
> 
