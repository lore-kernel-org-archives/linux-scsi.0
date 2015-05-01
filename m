From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: integrate scsi_dh better into the scsi core
Date: Fri, 01 May 2015 11:47:12 -0400
Message-ID: <yq1lhh8ti4f.fsf@sermon.lab.mkp.net>
References: <1430415151-30948-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28571 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbbEAPt1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2015 11:49:27 -0400
In-Reply-To: <1430415151-30948-1-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Thu, 30 Apr 2015 19:32:22 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> This series ties scsi_dh deeper into the scsi core, and fixes
Christoph> all kinds of issues in it, most importantly the race between
Christoph> using and detaching device handlers.

Very nice work!

-- 
Martin K. Petersen	Oracle Linux Engineering
