From: "Lee Xing" <lxing@Crossroads.com>
Subject: RE: Help - can Linux SCSI sub-system add newly-attached devices to/dev on the fly?
Date: Thu, 20 May 2004 13:04:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FEFFE@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:42938 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S265234AbUETSEN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 14:04:13 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

>> Mid-layer in lk 2.6 defines two functions, scsi_add_device() and scsi_add_host(),
>> that can be called by low-level drivers based on the document.  I'm not familiar 
>> with lk2.6.  Can low-level drivers in lk2.6 call scsi_add_device( ) to add 
>> newly-attached disks to mid-layer on the fly?

>Yes.  For an example take a look at drivers/ieee1394/sbp2.c.

>> Does lk2.4 provide a similar 
>> function to scsi_add_device( ) in lk2.6?

>No.

Thanks for the information (i.e. lk2.4 doesn't provide similar function to scsi_add_device() in lk2.6).

Does any one know if lk2.4 has **any other ways** low-level drivers can use to notify mid-layer the changes on the attached devices on the fly?

Thanks,


Lee
