From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [patch for playing] Patch to support 4000 disks and maintain backward compatibility
Date: Thu, 10 Apr 2003 16:37:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200304101637.53017.pbadari@us.ibm.com>
References: <UTC200304102333.h3ANXTi28340.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:33527 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264249AbTDJX2f convert rfc822-to-8bit (for <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2003 19:28:35 -0400
In-Reply-To: <UTC200304102333.h3ANXTi28340.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thursday 10 April 2003 04:33 pm, Andries.Brouwer@cwi.nl wrote:
>     From: Badari Pulavarty <pbadari@us.ibm.com>
>
>     > Then we don't know which disks have disappeared. Pity.
>     > If the number space is infinite then
>     >    index = next_index++;
>     > gives a new number each time we need one.
>
>     Yes !! I agree. I am not worried about running out them.
>     I am more worried about names slipping. I atleast hope
>     to see device names not changing by just doing
>     rmmod/insmod.
>
> But you see, the present sd_index_bits[] gives no such
> guarantee. In sd_detach a bit is cleared, in sd_attach
> the first free bit is given out. There is no memory.

But the disks are probed in the same manner as last time
(if the disks/controllers are not moved, crashed etc..). 
So we will end up getting same names.

Ofcourse, we need a device naming solution to fix
this for real.

Thanks,
Badari
