From: Brian King <brking@us.ibm.com>
Subject: Re: PROBLEM: Oops in 2.6.3 with lots of SG_IO activity - [PATCH]
Date: Tue, 09 Mar 2004 11:30:54 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <404DFF4E.9040000@us.ibm.com>
References: <04Mar9.110218est.332557@cyborg.cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:60907 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262070AbUCIRbb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2004 12:31:31 -0500
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

I tried out your patch and it didn't fix my problem. All it did was
reduce the window. I believe the patch I submitted should fix the
problem you were seeing as well.

-Brian


Tony Battersby wrote:
> I found a similar problem in 2.4 last year.  I posted a patch but it
> wasn't merged due to a minor technicality with memory barriers, and I
> forgot to follow up on the issue.  Sorry for dropping the ball on this
> one.  See http://marc.theaimsgroup.com/?t=105664088400001&r=1&w=2.  I
> believe the fix probably still needs to be merged in 2.4.
> 
> Anthony J. Battersby
> Cybernetics
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

