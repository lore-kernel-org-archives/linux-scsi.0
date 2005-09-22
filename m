From: "akshat verma" <akshat@lycos.com>
Subject: registering lun: add-single-device does not work
Date: Thu, 22 Sep 2005 04:42:57 -0500
Message-ID: <20050922094257.2734B3384B@ws7-3.us4.outblaze.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67]:19638 "EHLO
	webmail-outgoing.us4.outblaze.com") by vger.kernel.org with ESMTP
	id S1030242AbVIVJm5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2005 05:42:57 -0400
Received: from unknown (unknown [192.168.9.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id 319DA18002B0
	for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2005 09:42:57 +0000 (GMT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



> 
> I have been trying to register luns created on a FastT box with 
> my linux box..
> 
> the luns are visible to linux
> cat /proc/scsi/qla2200/0 returns the following..  as one can see, 
> the luns are not registered..
> ---------------
> QLogic PCI to Fibre Channel Host Adapter for QLA22xx:
>          Firmware version:  2.02.06, Driver version 7.01.01
> Entry address = f8831060
> HBA: QLA2200 , Serial# J17188
> Request Queue = 0x2b300000, Response Queue = 0x2b7f0000
> Request Queue count= 512, Response Queue count= 64
> Total number of active commands = 0
> Total number of interrupts = 51
> Total number of IOCBs (used/max) = (0/600)
> Total number of queued commands = 0
>      Device queue depth = 0x20
> Number of free request entries = 510
> Number of mailbox timeouts = 0
> Number of ISP aborts = 0
> Number of loop resyncs = 4
> Number of retries for empty slots = 0
> Number of reqs in pending_q= 0, retry_q= 0, done_q= 0, scsi_retry_q= 0
> Host adapter:loop state= <READY>, flags= 0x868811
> Dpc flags = 0x0
> MBX flags = 0x0
> SRB Free Count = 4096
> Link down Timeout = 000
> Port down retry = 030
> Login retry count = 030
> Commands retried with dropped frame(s) = 0
> 
> 
> SCSI Device Information:
> scsi-qla0-adapter-node=200000e08b0dc4fe;
> scsi-qla0-adapter-port=210000e08b0dc4fe;
> scsi-qla0-target-0=200b00a0b80be4d7;
> 
> SCSI LUN Information:
> (Id:Lun)  * - indicates lun is not registered with the OS.
> ( 0: 0): Total reqs 1, Pending reqs 0, flags 0x0*, 0:0:82,
> ( 0: 1): Total reqs 0, Pending reqs 0, flags 0x0*, 0:0:82,
> ( 0: 5): Total reqs 0, Pending reqs 0, flags 0x0*, 0:0:82,
> -------------------------------------------------------------------
> 
> and so going thru the lists, I figured that an
> echo "scsi add-single-device 0 0 0 0" > /proc/scsi/scsi
> should be able to register the lun.. however, it does not change anything..
> 
> I checked also at /proc/scsi/sg/devices but the device was not registered..
> 
> 0       0       0       0       3       0       32      0       0
> 1       0       0       0       0       2       31      0       1
> 3       0       0       0       5       0       5       0       1
> 
> trying to figure out the problem, I found that /proc/scsi/scsi has 
> only read permissions even for the root.. and I was unable to 
> change the permissions..
> now, my question is this..
> 1. how do I register the lun?
> 2. is a read only permission normal of /proc/scsi/scsi behavior ? ( 
> I am a newbie here)
> 3. is there anything I have messed up in my system settings? In 
> that case, shld I restart from scratch (creating luns etc).. any 
> suggestions, obvious mistakes I might have made here..
> 
> thanks,
> akshat
> 
> P.S - please cc me any reply as well..
> 
> 
> --
> _______________________________________________
> 
> Search for businesses by name, location, or phone number.  -Lycos Yellow Pages
> 
> http://r.lycos.com/r/yp_emailfooter/http://yellowpages.lycos.com/default.asp?SRC=lycos10
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Please send me mails in future on akshatverma@gmail.com 

AKSHAT VERMA

Life should be enjoyable; too often we think it's about achievement.
The truth is that making life enjoyable is an achievement in itself.


-- 
_______________________________________________

Search for businesses by name, location, or phone number.  -Lycos Yellow Pages

http://r.lycos.com/r/yp_emailfooter/http://yellowpages.lycos.com/default.asp?SRC=lycos10

