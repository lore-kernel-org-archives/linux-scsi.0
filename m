From: "Jing Huang" <huangj@Brocade.COM>
Subject: RE: [PATCH 5/6] bfa: Brocade BFA FC SCSI driver submission (2ndtry)
Date: Thu, 25 Sep 2008 21:49:27 -0700
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E01F28079@HQ-EXCH-5.corp.brocade.com>
References: <200809260106.m8Q160kj028501@swe37.brocade.com> <20080926025514.GD9480@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx30.brocade.com ([144.49.194.4]:14754 "EHLO mx30.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbYIZEtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2008 00:49:32 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080926025514.GD9480@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, "Srikanth Rayas (CW)" <srayas@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>

The reason we creating our own sysfs directory under /sys/devices path
was we felt the fc transport and scsi host attributes are not enough for
all the HBA management features we want to have. We have ioctl in our
non opensource driver, and we want to have something to emulate all/most
of the IOCTL functionality we have in the opensource driver. We provide
multi-level of driver/fw statistics info to the user, and we want to put
those info under a separate directory instead of throw them all under
scsi_host. I just didn't know how to create a subdirectory under scsi/fc
host. Currently, we only implement a small portion of all the IOCTL
functionalities. We want to know if this is acceptable in the upstream
kernel. 

I agree that there are a lot of redundancy with the attributes we
created under scsi_host. We will clean them up.

Jing

-----Original Message-----
From: Greg KH [mailto:greg@kroah.com] 
Sent: Thursday, September 25, 2008 7:55 PM
To: Jing Huang
Cc: James.Bottomley@HansenPartnership.com; linux-kernel@vger.kernel.org;
linux-scsi@vger.kernel.org; Ramkumar Vadivelu; Srikanth Rayas (CW);
Vinodh Ravindran
Subject: Re: [PATCH 5/6] bfa: Brocade BFA FC SCSI driver submission
(2ndtry)

On Thu, Sep 25, 2008 at 06:06:00PM -0700, Jing Huang wrote:
> From: Jing Huang <huangj@brocade.com>
> 
> This patch contains document of brocade specific sysfs interface.
> It is created using 2.6.27-rc7 kernel.

What about my question for the need for all of these files and using
debugfs instead?

thanks,

greg k-h
