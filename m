From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 5/5] sd: Implement support for WRITE SAME
Date: Mon, 20 Feb 2012 12:36:51 -0500
Message-ID: <yq17gzh5rv0.fsf@sermon.lab.mkp.net>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
	<1327969892-5090-6-git-send-email-martin.petersen@oracle.com>
	<20120220161645.GA29207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:19738 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab2BTRhA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2012 12:37:00 -0500
In-Reply-To: <20120220161645.GA29207@redhat.com> (Mike Snitzer's message of
	"Mon, 20 Feb 2012 11:16:45 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Just a small nit, this should be scsi_setup_write_same_cmnd given
Mike> we already have: scsi_setup_{discard,flush}_cmnd

This was deliberate. It's the two other functions that are
misnamed. They clearly belong in the sd_ name space.

-- 
Martin K. Petersen	Oracle Linux Engineering
