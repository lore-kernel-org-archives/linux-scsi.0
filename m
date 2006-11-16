From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/8] target mode support
Date: Thu, 16 Nov 2006 10:32:25 -0600
Message-ID: <455C9299.5010202@cs.wisc.edu>
References: <20061116192358C.fujita.tomonori@lab.ntt.co.jp> <455C76D1.9050501@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:2267 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030926AbWKPQcr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Nov 2006 11:32:47 -0500
In-Reply-To: <455C76D1.9050501@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James Bottomley <James.Bottomley@SteelEye.com>

James Smart wrote:
> One question....
> 
> Does this assume that an hba is both initiator and target ?  target only ?
> Do we have any issues if a scsi_host is a target only ?
> 

I do not think that is fully worked out yet. The only target that is
done is the vscsi one which is a little different from something like
lpfc or qla*. I think some developers like Qlogic would prefer the
driver and card is only in one mode or the other to simplify things.
However, I think Tomo and users would like to be able to use a
card/driver in both modes at the same time.
