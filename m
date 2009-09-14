From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [RFC PATCH 0/9] RFC: handle queue_depth adjustments because of
	QUEUE_FULLs in scsi_error.c
Date: Mon, 14 Sep 2009 13:21:01 +0200
Message-ID: <20090914112100.GA27084@schmichrtp>
References: <20090826180234.23396.8148.stgit@vi1.jf.intel.com> <1251845853.27437.69.camel@vi2.jf.intel.com> <4A9DCE5D.2040208@cs.wisc.edu> <1251914477.29277.101.camel@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:47856 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZINLU7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2009 07:20:59 -0400
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate1.uk.ibm.com (8.13.1/8.13.1) with ESMTP id n8EBL2UF014293
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2009 11:21:02 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8EBL1M73137774
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2009 12:21:02 +0100
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8EBL18D017303
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2009 12:21:01 +0100
Content-Disposition: inline
In-Reply-To: <1251914477.29277.101.camel@vi2.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

On Wed, Sep 02, 2009 at 11:01:17AM -0700, Vasu Dev wrote:
> > You can/should probably also pick up Christop's stuff too for him (zfcp 
> > patches).
> 
> Christof, I'm fine picking up your patch also, let me know if that is
> not fine with you.

Pick up the patch, that is ok with me. I guess it makes most sense to
apply this in one run.

I have not seen the patches in scsi-misc yet. Will this go into 2.6.32?

--
Christof
