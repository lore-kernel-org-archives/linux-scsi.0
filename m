From: Michael Clark <michael@metaparadigm.com>
Subject: Re: Enterprise patch needed - please help
Date: Thu, 30 May 2002 20:43:18 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CF61E66.1050600@metaparadigm.com>
References: <6BD67FFB937FD411A04F00D0B74FE87807C249F0@xrose06.rose.hp.com>	<1022719300.4124.312.camel@irongate.swansea.linux.org.uk> 	<3CF5AEA4.4050404@metaparadigm.com> <1022762307.4123.364.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "HINCHMAN,PAUL (HP-Roseville,ex1)" <paul_hinchman@hp.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>


On 05/30/02 20:38, Alan Cox wrote:

>On Thu, 2002-05-30 at 05:46, Michael Clark wrote:
>  
>
>>Also, some devices need a BLIST_SPARSELUN added in scsi_scan.c - even if 
>>the device
>>reports SCSI-3, the scanning code by defaults stops when it finds a lun 
>>that doesn't
>>respond. It is quite common with enterpise storage to have sparse 
>>between luns.
>>    
>>
>
>If we use report luns should we even be checking BLIST_SPARSELUN I
>wonder
>
>  
>
Oh, is this new or maybe my device doesn't report luns as I've needed
the sparse lun hint even though device was correctly detected as SCSI-3.
This is with 2.4.18

