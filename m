From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/2] FC pass through support via bsg interface - revised
Date: Tue, 14 Oct 2008 11:23:02 +0900
Message-ID: <20081014112308T.fujita.tomonori@lab.ntt.co.jp>
References: <B5FBFF85-C7C0-44F7-905F-9029C54F4F56@qlogic.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:43733 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbYJNCXd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Oct 2008 22:23:33 -0400
In-Reply-To: <B5FBFF85-C7C0-44F7-905F-9029C54F4F56@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: seokmann.ju@qlogic.com
Cc: James.Smart@Emulex.Com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, bharrosh@panasas.com, robert.w.love@intel.com

On Mon, 13 Oct 2008 10:53:18 -0700
Seokmann Ju <seokmann.ju@qlogic.com> wrote:

> Base on feedback as below, here is revised one for pass through support.
> http://marc.info/?l=linux-scsi&m=122123825918741&w=2
> http://marc.info/?t=121908849700001&r=1&w=2
> 
> Also, the attached file is updated sample application along with GPL  
> license.

Can you summarize what changes you made since the previous version
(based on the feedback)?
