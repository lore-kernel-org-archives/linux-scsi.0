From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: scsi_free_sdev and slave destroy
Date: 25 Nov 2003 09:23:23 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069773808.2061.6.camel@mulgrave>
References: <200311252037.34015.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:30471 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262745AbTKYPXt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 10:23:49 -0500
In-Reply-To: <200311252037.34015.krmurthy@cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Krishna Murthy <krmurthy@cisco.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

On Tue, 2003-11-25 at 09:07, Krishna Murthy wrote:
> 		scsi_alloc_sdev
> 		probe for the lun
> 		If lun does not exist call scsi_free_sdev.
> 
> scsi_alloc_sdev calls slave_alloc of the HBA driver where as 
> scsi_free_sdev does not seem to call slave_destroy.
> Please let me know if this is a bug or I am missing something.

This is a current bug and is fixed in the latest scsi patch set.

James


