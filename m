From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 0/8] target mode support
Date: Thu, 16 Nov 2006 09:33:53 -0500
Message-ID: <455C76D1.9050501@emulex.com>
References: <20061116192358C.fujita.tomonori@lab.ntt.co.jp>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:8608 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S933513AbWKPOeV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Nov 2006 09:34:21 -0500
In-Reply-To: <20061116192358C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James Bottomley <James.Bottomley@SteelEye.com>

One question....

Does this assume that an hba is both initiator and target ?  target only ?
Do we have any issues if a scsi_host is a target only ?

-- james s

FUJITA Tomonori wrote:
> The following patchset adds the target mode support in
> user-space. This has been living in the -mm tree for a while. Mike and
> I think it's ready for mainline inclusion.
> 
> The user-space tools and documents are available at:
> 
> http://stgt.berlios.de/
> 
> This patchset can be applied to both scsi-misc-2.6 and linux-2.6
> trees.
> 
> 
> The first two patches are for the block layer. The second patch is the
> following 'support larger block pc requests' patch in the bsg tree:
> 
> http://kernel.org/git/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=d872a1b22a09dffd7b48609f80f80dfa6e78227e
> 
> It's a slightly modified version since scsi_ioctl.c in the bsg tree
> was cleaned up.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
