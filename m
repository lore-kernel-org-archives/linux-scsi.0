From: boutcher@cs.umn.edu (Dave C Boutcher)
Subject: Re: [GIT PATCH] SCSI updates for 2.6.17
Date: Thu, 22 Jun 2006 11:47:45 -0500
Message-ID: <17562.51633.184908.912163@hound.rchland.ibm.com>
References: <1150837947.2531.27.camel@mulgrave.il.steeleye.com>
	<4498A050.8080403@torque.net>
	<20060621130745.aed5d1c9.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.36.202]:33745 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S1751485AbWFVQr5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jun 2006 12:47:57 -0400
Received: from localhost (localhost [127.0.0.1])
	by augustus.cs.umn.edu (Postfix) with ESMTP id 5801E5C3B2
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jun 2006 11:47:57 -0500 (CDT)
Received: from mail.cs.umn.edu ([127.0.0.1])
 by localhost (mail.cs.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id 07402-01-6 for <linux-scsi@vger.kernel.org>;
 Thu, 22 Jun 2006 11:47:54 -0500 (CDT)
Received: from oxygen.cs.umn.edu (oxygen.cs.umn.edu [128.101.35.179])
	by mail.cs.umn.edu (Postfix) with ESMTP id 9DD685C39E
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jun 2006 11:47:54 -0500 (CDT)
In-Reply-To: <20060621130745.aed5d1c9.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wed, 21 Jun 2006 13:07:45 -0700, "Randy.Dunlap" <rdunlap@xenotime.net> said:
> 
> On Tue, 20 Jun 2006 21:26:40 -0400 Douglas Gilbert wrote:
>> James Bottomley wrote:
>> > This represents the almost complete SCSI pending list apart from a SAS
>> > port update which we're still trying to beat into shape.  The patch can
>> > be pulled from here:
>> > 
>> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
>> > 
>> > The short changelog is:
>> 
>> <snip>
>> 
>> James,
>> I was hoping to see my scsi_debug update in there:
>> "[PATCH] scsi_debug version 1.79 against 2.6.17-rc5"
>> 
>> http://marc.theaimsgroup.com/?l=linux-scsi&m=114956710925458&w=2
> 
> Similarly, my patches for:
> 
> wd7000: fix section mismatches
>   http://marc.theaimsgroup.com/?l=linux-scsi&m=114857569131744&w=2
> qla1280: fix section mismatches
>   http://marc.theaimsgroup.com/?l=linux-scsi&m=114857863523008&w=2
> advansys: fix section mismatches
>   http://marc.theaimsgroup.com/?l=linux-scsi&m=114982511005563&w=2

And even 

[PATCH] ibmvscsi: treat busy and error conditions separately
    http://marc.theaimsgroup.com/?l=linux-scsi&m=115016541505390&w=2

Dave B
