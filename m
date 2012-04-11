From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Wed, 11 Apr 2012 16:46:38 -0500
Message-ID: <4F85FBBE.8060006@cs.wisc.edu>
References: <4F7DA4F8.90104@redhat.com> <4F7DDDCC.1070506@acm.org> <4F7E0EBF.80407@cs.wisc.edu> <4F7EB658.9060109@acm.org> <4F7F2652.8030306@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45574 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760879Ab2DKVqt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Apr 2012 17:46:49 -0400
In-Reply-To: <4F7F2652.8030306@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Tomas Henzl <thenzl@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>

On 04/06/2012 12:22 PM, Mike Christie wrote:
> 1. A transport class or scsi_sysfs.c initiate a scan.
> 2. A user could rmmod the LLD.
> 3. The LLD will call the transport remove host if there is one and then
> scsi_remove_host.

You do not have to worry about this. The scsi scan mutex and host state
checks will protect against it.
