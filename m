From: David Wysochanski <davidw@netapp.com>
Subject: Re: [PATCH] Recognize missing LUNs for non-standard devices
Date: Tue, 07 Feb 2006 15:44:38 -0500
Message-ID: <43E906B6.3000903@netapp.com>
References: <Pine.LNX.4.44L0.0602071027340.5164-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:49524 "EHLO mx2.netapp.com")
	by vger.kernel.org with ESMTP id S932182AbWBGU5h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2006 15:57:37 -0500
In-Reply-To: <Pine.LNX.4.44L0.0602071027340.5164-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Brian King <brking@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Tue, 7 Feb 2006, Brian King wrote:
> 
>  > > I was afraid that might happen.  Okay, forget the patch.
>  > >
>  > > How come you didn't mention the ipr driver before when I first raised the
>  > > possibility of making this change?
>  >
>  > Sorry about that... I wanted to verify on my end that the scsi level getting
>  > returned was 0 before doing so. Your repost was a reminder...
> 
> Maybe there's a way around this.  Would it be okay to add a flag to the
> target structure, to indicate that PDT = 0x1f should be interpreted as "No
> LUN present"?
> 
> Alan Stern
> 

I have this same problem for netapp targets (different scsi_level)
and have been meaning to submit a patch so I'm interested in any
patch you might have.
