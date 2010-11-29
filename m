From: "Ed Lin - PTU" <ed.lin@promise.com>
Subject: RE: [dm-devel] QUEUE_FLAG_CLUSTER?
Date: Mon, 29 Nov 2010 11:08:50 -0800
Message-ID: <85ABFDC4641C4847BA6088F2982EFD8F04A4A669@nonamew.ptu.promise.com>
References: <yq14ob5o2d4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:65407 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750921Ab0K2TIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2010 14:08:52 -0500
Content-class: urn:content-classes:message
In-Reply-To: <yq14ob5o2d4.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi@vger.kernel.org, Promise_Linux <Promise_Linux@promise.com>


>We should never issue a command that does not adhere to the limits set
>by the device driver. Upon inspection I agree this is busted 
>and it's my
>fault.
>
>DM does not have a request_queue when stacking and as a result we ended
>up with two entities tracking whether a device supports clustering or
>not. And as it turns out the queue flag and the queue limits are not
>always in agreement.
>
>I've coded up a proper fix for this and will post a patch shortly. I'm
>just running a bunch of tests to ensure we do the right thing...
>

Hi Martin,

I will do some test with your later patch. But obviously it is a
thorough fix of the problem, eliminating all the confusing dual flag
thing in the original code.

Is it possible to port the patch to previous kernels?

Thanks, much appreciated.

Ed Lin
