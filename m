From: Jens Axboe <axboe@suse.de>
Subject: Re: CD Recorder does not work with 2.6
Date: Thu, 4 Mar 2004 11:24:57 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040304102457.GE2708@suse.de>
References: <pan.2004.03.04.10.15.33.654587@mhcsoftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:58522 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261816AbUCDKZB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2004 05:25:01 -0500
Content-Disposition: inline
In-Reply-To: <pan.2004.03.04.10.15.33.654587@mhcsoftware.de>
List-Id: linux-scsi@vger.kernel.org
To: Matthias Henze <matthias@mhcsoftware.de>
Cc: linux-scsi@vger.kernel.org

On Thu, Mar 04 2004, Matthias Henze wrote:
> hi,
> 
> my problem:
> 
> mount /dev/sr0  hangs forever and could not be killed.
> 
> cdrecord -scanbus shows:
> 
> Linux sg driver version: 3.5.30
> Using libscg version 'schily-0.8'.
> scsibus0:
>         0,0,0     0) *
>         0,1,0     1) *
>         0,2,0     2) *
>         0,3,0     3) *
>         0,4,0     4) *
> 
> and hangs forever, but could be stoped with crtl-c
> 
> 
> everything used to work fine with kernel 2.4.
> 
> I've upgraded to kernel 2.6.3 on a debian sid based system. dmesg shows:

Known problem, upgrade to 2.6.4-rc2

-- 
Jens Axboe

