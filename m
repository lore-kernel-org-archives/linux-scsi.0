From: Rock Gordon <rockgordon@yahoo.com>
Subject: Re: WWN on FC LUN targets
Date: Wed, 4 Aug 2004 10:04:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040804170433.52447.qmail@web41404.mail.yahoo.com>
References: <410CB26E.7060109@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web41404.mail.yahoo.com ([66.218.93.70]:2999 "HELO
	web41404.mail.yahoo.com") by vger.kernel.org with SMTP
	id S267314AbUHDREg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Aug 2004 13:04:36 -0400
In-Reply-To: <410CB26E.7060109@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, Bryan Henderson <hbryan@us.ibm.com>
Cc: Rock Gordon <rockgordon@yahoo.com>, linux-scsi@vger.kernel.org

Hi everyone, thanks once again for your replies!

The sg3_utils is very good - I will probably rely on
them.

On a related note - the /proc/partitions file can
handle only one page worth of entries for 2.4.18,
right? There might be a strong possibility of "losing"
entries due to this restriction. Is there any patch
out there to get around this problem?

Thanks,

> 
> The scsi_id program by Patrick Mansfield queries a
> SCSI device's
> identification and serial number vital product data
> (VPD) pages
> and produces a unique number. It is meant to be used
> in conjunction
> with udev (a dynamic device node creation, naming
> and removal facility
> based on the hotplug subsystem in the lk 2.6 series)
> to create device
> (and partition) node names according to user
> specified rules.
> Several versions can be found at this url:
>     http://www-124.ibm.com/storageio/scsi_id/
> 
> The sg_inq utility in the sg3_utils package (version
> 1.07) has
> a '-i' option that will decode all the
> "identification descriptors"
> in the device identification VPD page (0x83) for the
> nominated device.
> That information in conjunction with some of the
> explanations in
> this thread may show you what identifiers, if any,
> are available.
> The unit serial number page can be queried with
> 'sg_inq -o=80 /dev/sda'.
> sg3_utils can be found at: http://www.torque.net/sg
> 
> SPC-3 (SCSI Primary Commands) can be found
> http://www.t10.org
> The most recent draft is version 19 and section
> 7.6.4 and 7.6.11
> are relevant.
> 
> Doug Gilbert
> 


		
__________________________________
Do you Yahoo!?
Yahoo! Mail is new and improved - Check it out!
http://promotions.yahoo.com/new_mail
