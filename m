From: "Lee Xing" <lxing@Crossroads.com>
Subject: RE: How does low-level driver report disks changes to mid-level on the fly?
Date: Fri, 14 May 2004 18:34:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FF8C5@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:21402 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S264628AbUENXeB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 May 2004 19:34:01 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Sorry, I forgot to say this is in lk 2.4 environment.

>  -----Original Message-----
> From: 	Lee Xing  
> Sent:	Friday, May 14, 2004 6:29 PM
> To:	linux-scsi@vger.kernel.org
> Subject:	How does low-level driver report disks changes to mid-level on the fly?
> 
> Hi Gentlemen,
> 
> Could some one please give me some information/hint on this question?
> 
> Suppose we hot plug-in or pull-off FC disks, how does the low-level driver report such disk/device changes to SCSI mid-level driver **on the fly**?  Can low-level driver "manually" call scsi_register_module() to re-register itself, which in turn calls scsi_register_host() then scan_scsis(), or should low-level driver do something else?
> 
> Thanks in advance,
> 
> 
> Lee
> 
> 
