From: Sachin Sant <sachinp@in.ibm.com>
Subject: Re: Next March 25: Boot failure on powerpc [recursive locking detected]
Date: Thu, 26 Mar 2009 12:04:40 +0530
Message-ID: <49CB2200.50703@in.ibm.com>
References: <20090325191229.0e17eaf6.sfr@canb.auug.org.au> <49CA3BF4.3050801@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <49CA3BF4.3050801@in.ibm.com>
Sender: linux-next-owner@vger.kernel.org
To: linuxppc-dev@ozlabs.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

Sachin Sant wrote:
> Today's next failed to boot on a powerpc box
> (Power6 blade IBM,7998-61X) with following recursive locking message.
>
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.29-next-20090325 #1
After bisecting the failure seems to be because of the following
patch from James ( block: move SCSI timeout check into block )

http://patchwork.kernel.org/patch/8017/

If i back out the above mentioned patch, the machine boots fine
without any problems.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------
