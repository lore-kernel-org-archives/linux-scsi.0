From: Michael Clark <michael@metaparadigm.com>
Subject: Re: Enterprise patch needed - please help
Date: Thu, 30 May 2002 12:46:28 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CF5AEA4.4050404@metaparadigm.com>
References: <6BD67FFB937FD411A04F00D0B74FE87807C249F0@xrose06.rose.hp.com> <1022719300.4124.312.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "HINCHMAN,PAUL (HP-Roseville,ex1)" <paul_hinchman@hp.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>



On 05/30/02 08:41, Alan Cox wrote:

>On Thu, 2002-05-30 at 00:23, HINCHMAN,PAUL (HP-Roseville,ex1) wrote:
>  
>
>>negates support from whatever vendor (like SuSE and Red Hat).  So, an
>>"out-of-the-box" solution is desparately needed.  Linux won't go far in the
>>enterprise without fully enabled (and stress-tested) storage.  I'd like to
>>see this change to the 2.4.18+ kernels and beyond, I think it would probably
>>be simple. Any advice you folks could give me as to who to talk to and
>>escalate this issue would be great.  I'll provide more info to anyone who
>>thinks they can help.
>>    
>>
>
>What I am more curious about is why your storage system didn't get
>enumerating using the SCSI-3 report luns code path
>

There was a bug regarding this a few revisions ago (2.4.17 it was fixed) 
where
even if the device reported SCSI-3, it still wouldn't scan past 8 luns. 
This bug
didn't exist in RedHat kernels.

Also, some devices need a BLIST_SPARSELUN added in scsi_scan.c - even if 
the device
reports SCSI-3, the scanning code by defaults stops when it finds a lun 
that doesn't
respond. It is quite common with enterpise storage to have sparse 
between luns.

~mc

