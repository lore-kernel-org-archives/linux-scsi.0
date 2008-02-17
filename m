From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi_debug: disable clustering
Date: Sun, 17 Feb 2008 07:10:45 -0700
Message-ID: <20080217141045.GB21012@parisc-linux.org>
References: <20080216235714H.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54258 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbYBQOKq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Feb 2008 09:10:46 -0500
Content-Disposition: inline
In-Reply-To: <20080216235714H.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@hansenpartnership.com, dougg@torque.net, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Sat, Feb 16, 2008 at 11:57:15PM +0900, FUJITA Tomonori wrote:
> scsi_debug does at several places:
> 
> for_each_sg(sdb->table.sgl, sg, sdb->table.nents, k) {
> 	kaddr = (unsigned char *)
> 		kmap_atomic(sg_page(sg), KM_USER0);
> 
> 
> We cannot do something like that with the clustering enabled (or we
> can use scsi_kmap_atomic_sg).

Why not?  Is KM_USER0 used for something else with clstering enabled?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
