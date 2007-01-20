From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] sd: implement stop_on_shutdown
Date: Sat, 20 Jan 2007 18:59:59 +0900
Message-ID: <45B1E81F.5060107@gmail.com>
References: <20070119170122.GS10987@htj.dyndns.org> <45B1574D.1090502@us.ibm.com> <45B18AE2.3010503@gmail.com> <45B1E5D3.90101@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.235]:53725 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965231AbXATKAM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Jan 2007 05:00:12 -0500
Received: by nz-out-0506.google.com with SMTP id s1so573679nze
        for <linux-scsi@vger.kernel.org>; Sat, 20 Jan 2007 02:00:11 -0800 (PST)
In-Reply-To: <45B1E5D3.90101@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, James.Bottomley@SteelEye.com, hmh@hmh.eng.br, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Tejun Heo wrote:
>> For ATA, it's currently being done inside libata proper (a bit ugly).
>> It would be nice to have those implemented at sd layer but I wonder how
>> useful it's going to be for actual SCSI devices.  Do people actually
>> suspend using SCSI?  If it's useful at the SCSI layer, I can implement
>> and test it with SATA devices here.
> 
> There is always the open question for multi-initiator SCSI devices, as
> to who "owns" the SCSI device.  Some devices should be suspended/stopped
> when the machine is suspended/stopped, others not.

I think that can be handled similarly as stop_on_shutdown on kernel side
and let udev and friends deal with the specifics.

Thanks.

-- 
tejun
