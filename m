From: malahal@us.ibm.com
Subject: Re: [PATCH 05 of 16] Block layer data integrity
Date: Tue, 6 May 2008 19:50:20 -0700
Message-ID: <20080507025019.GA32000@us.ibm.com>
References: <patchbomb.1209165122@sermon.lab.mkp.net> <26ccaf2ccdc5548c4c9f.1209165127@sermon.lab.mkp.net> <20080506202909.GA25904@us.ibm.com> <yq1d4nyyizo.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:42004 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067AbYEGCuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2008 22:50:21 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m472lLEq002325
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2008 22:47:21 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m472oKUP148208
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2008 20:50:20 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m472oKXv014190
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2008 20:50:20 -0600
Received: from malahal.beaverton.ibm.com (malahal.beaverton.ibm.com [9.47.17.130])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m472oKJ2014182
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2008 20:50:20 -0600
Content-Disposition: inline
In-Reply-To: <yq1d4nyyizo.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Martin K. Petersen [martin.petersen@oracle.com] wrote:
> But generally, yes.  It is up to the submitter to guarantee that the
> page isn't being modified during I/O.  This requirement will trickle
> all the way to the top of the stack for things like direct I/O.

Understandable for direct I/O. How does an application using mmap for
writing can control this? Does that mean mmap writes are not really
supported?

--Malahal.
