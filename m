From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/2] osst: remove scsi_execute_async usage
Date: Sun, 11 Jan 2009 13:44:13 +0900
Message-ID: <20090111134402U.fujita.tomonori@lab.ntt.co.jp>
References: <1229183718-1171-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:33139 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbZAKEoV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2009 23:44:21 -0500
In-Reply-To: <1229183718-1171-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: osst@riede.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Sun, 14 Dec 2008 00:55:16 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> This patchset removes scsi_execute_async usage in osst driver. IOW,
> this converts osst driver to use the block layer functions. We are in
> the process of removing scsi_execute_async and
> scsi_req_map_sg. scsi_execute_async in sg driver were removed in
> 2.6.27. The patchset to remove scsi_execute_async in st is available
> (the first half patchset was already merged into scsi-misc). osst is
> the last user.
> 
> This is against scsi-misc and depends on 'removing scsi_execute_async
> in st' the second half patchset:
> 
> http://marc.info/?l=linux-scsi&m=122900494917385&w=2

Willem, any change to test the patches? They can be cleanly applied to
2.6.29-rc1.


Thanks,
