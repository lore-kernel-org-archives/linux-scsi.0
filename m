From: MShetty <mranalini.shetty@patni.com>
Subject: Re: Executing a scsi command
Date: Fri, 08 Nov 2002 21:52:32 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DCBE4C7.DB1AEE9F@patni.com>
References: <3DCA6E46.91894890@patni.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from antivirusgw.patni.com (rakshak.patni.com [203.124.139.54])
	by pcsbom.patni.com (8.9.3/8.8.8) with SMTP id VAA17280
	for <linux-scsi@vger.kernel.org>; Fri, 8 Nov 2002 21:43:27 +0530 (IST)
Received: from akash.patni.com ([192.168.0.12])
 by antivirusgw.patni.com (NAVGW 2.5.2.12) with SMTP id M2002110821432617938
 for <linux-scsi@vger.kernel.org>; Fri, 08 Nov 2002 21:43:26 +0530
Received: from patni.com ([204.165.187.192]) by akash.patni.com (8.9.3/SCO5) with ESMTP id VAA10207 for <linux-scsi@vger.kernel.org>; Fri, 8 Nov 2002 21:43:22 +0530 (IST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi,

Does request_queue's queuedata contain the Scsi_Device pointer ?? Saw it
done in scsi_merge.c

      Scsi_Device *SDpnt;
      struct Scsi_Host *SHpnt;

      SDpnt = (Scsi_Device *) q->queuedata;
      SHpnt = SDpnt->host;

Would help if I could get some comment on the above.

Thanks and Regards,
M Shetty

MShetty wrote:

> Hi,
>
> I want to execute a scsi cmd from my driver. The API's that I found
> (scsi_do_cmd, scsi_wait_req) require a pointer to the scsi_device or
> scsi_host structure.. Any idea how I could get them.... given the major
> and minor no. of the device to which the command is to be sent.
>
> Is there an alternative way of executing a scsi_cmd ??
>
> Would help if I could get some help on the above.
>
> Thanks and Regards,
> M Shetty
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

