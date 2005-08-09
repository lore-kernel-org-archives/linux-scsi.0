From: "Martin J. Bligh" <mbligh@mbligh.org>
Subject: Re: [Bugme-new] [Bug 5003] New: Problem with symbios driver	on	recent	-mm trees
Date: Tue, 09 Aug 2005 07:59:42 -0700
Message-ID: <531000000.1123599581@[10.10.2.4]>
References: <135040000.1123216397@[10.10.2.4]> <20050804233927.2d3abb16.akpm@osdl.org> <1123251892.5003.6.camel@mulgrave> <179280000.1123252564@[10.10.2.4]> <1123254086.5003.10.camel@mulgrave> <453380000.1123562466@[10.10.2.4]> <1123597604.5170.10.camel@mulgrave>
Reply-To: "Martin J. Bligh" <mbligh@mbligh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dvhart.com ([64.146.134.43]:42881 "EHLO localhost.localdomain")
	by vger.kernel.org with ESMTP id S964814AbVHIO7l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2005 10:59:41 -0400
In-Reply-To: <1123597604.5170.10.camel@mulgrave>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, bugme-daemon@kernel-bugs.osdl.org



--James Bottomley <James.Bottomley@SteelEye.com> wrote (on Tuesday, August 09, 2005 09:26:44 -0500):

> On Mon, 2005-08-08 at 21:41 -0700, Martin J. Bligh wrote:
>> Nope, is the same as before with this patch ....
> 
> Dear novice bug reporter,
> 
> Thank you for taking the trouble to test this.  Unfortunately, without
> any dmesg output, it's rather hard to tell what's going on here.  Would
> you be so kind as to send this information so we can try to diagnose
> what's going on.

Dear novice test examiner,

It's in http://test.kernel.org with everything else ;-)
2.6.13-rc4-mm1+jejb_fix ... drills down to:

http://test.kernel.org/10080/debug/console.log

M.

