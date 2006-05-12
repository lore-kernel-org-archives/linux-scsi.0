From: Kumba <kumba@gentoo.org>
Subject: Re: qla1280: failing mbox check
Date: Fri, 12 May 2006 09:07:22 -0400
Message-ID: <4464888A.1000807@gentoo.org>
References: <446409CA.2090100@gentoo.org> <yq04pzvr9dz.fsf@jaguar.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.192.81]:6095 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S1751279AbWELNHO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 09:07:14 -0400
In-Reply-To: <yq04pzvr9dz.fsf@jaguar.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Jes Sorensen wrote:
> 'git bisect' is your friend here.
> 
> Cheers,
> Jes

That was the answer I was afraid of....  Already tried using git bisect to track 
down a bootmem allocation bug in SGI O2 systems (2.6.17 just broke everything it 
seems...), but the bisection point happened to be around the time when all the 
bitops changes were occuring (moving duplicate functions from asm-mips -> 
asm-generic), resulting in a tree that wouldn't even compile.

Having to patch up a broken tree so it even builds to determine if the bisection 
is good or bad might obscure the bug, but well, guess that's something to try on 
the weekend.

Offhand, though, is there anything I should keep an eye out for that can do 
things like setting mb[] to 0x0 (i.e., things you guys might've seen happen in 
the past?).  And what do those numbers for 'mailbox0', 'ictrl', and 'istatus' 
mean (I'm guessing not much, because they're probably qla1040-specific error 
codes that require chip docs to understand).


--Kumba

-- 
Gentoo/MIPS Team Lead
Gentoo Foundation Board of Trustees

"Such is oft the course of deeds that move the wheels of the world: small hands 
do them because they must, while the eyes of the great are elsewhere."  --Elrond
