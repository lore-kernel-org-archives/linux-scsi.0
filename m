From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Soft lockup in scsi_remove_target under 3.6 (regression from
 3.5)
Date: Tue, 02 Oct 2012 22:46:22 -0500
Message-ID: <506BB50E.7090707@cs.wisc.edu>
References: <20121003004309.GA2289@earth.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58762 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab2JCDqd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2012 23:46:33 -0400
In-Reply-To: <20121003004309.GA2289@earth.li>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan McDowell <noodles@earth.li>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 10/02/2012 07:43 PM, Jonathan McDowell wrote:
> Upgraded to 3.6 today on my dev box and after seeing an FC attached SAN
> go down and come back up (due to an expected reboot) I started getting
> the following in my logs. It continues even after the array is back and
> functioning - I'm seeing:
> 
>  kernel:[109104.348034] BUG: soft lockup - CPU#6 stuck for 23s!
> [kworker/6:0:30692]
> 
> repeated on logged in sessions and backtraces like the following (this
> is the first). I don't see the same problem under 3.5.
> 


I think you need this patch
http://marc.info/?l=linux-scsi&m=134621716223056&w=2
