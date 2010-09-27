From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] block: Ensure physical block size is unsigned int
Date: Mon, 27 Sep 2010 13:40:52 -0400
Message-ID: <20100927174052.GA14180@redhat.com>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
 <1285605664-27027-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759204Ab0I0Rk5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2010 13:40:57 -0400
Content-Disposition: inline
In-Reply-To: <1285605664-27027-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

On Mon, Sep 27 2010 at 12:41pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> Physical block size was declared unsigned int to accomodate the maximum
> size reported by READ CAPACITY(16).  Make sure we use the right type in
> the related functions.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>
