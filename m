From: =?ISO-8859-1?Q?Gustavo_Mart=EDn?= <gmartin@filmayer.es>
Subject: Re: Problems with SCSI device
Date: Wed, 26 Mar 2003 16:36:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E81C8E3.6060002@filmayer.es>
References: <200303251947.h2PJlrci091863@mail5.mx.voyager.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: David Horton <dhorton@megsinet.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

  Hi again,

thanks Dave. No the conection with the device doesn't hang. But I still 
have problems. When I try to initialize the device I get the following 
error:

    The SCSI INQUIRY for device '/dev/nst0' failed (power off?)
    Definition for '/dev/st0' failed.

What it can be this time? I have created and configured the stinit.def   
file (not .conf file 'cause in the man page for stinit is the file that 
sugests)  as you told me. I don't know if it is well configured because 
I don't have the specifications of my drive.

Does any one of you have any idea of where the problem can be?

Thanks,
GUSTAVO

David Horton wrote:

>>Hi you all,
>>
>>I have a problem with a HP DLT 80 an Red Hat 8.0 Psyche. Everything 
>>seems to be well installed. Both devices st0 and nst0 have been created 
>>correctly, but when I try to tar something to the tape, an error message 
>>appears and connection with the SCSI device keeps opened. The only thing 
>>I can do is to erase the tape (using mt command). I have an aic 7xxx 
>>device. I don't know if this has something to do with it.
>>
>>Regards,
>>GUSTAVO
>>
>>
>>    
>>
>
>Have you tried initializing the tape drive parameters with 'stinit'?  I
>have an older HP 5000 DAT that acts like it is broken unless 'stinit' is
>run in my startup scripts.  The 'stinit' program is part of the 'mt'
>package so it should be installed on your box already.  You'll need to
>setup /etc/stinit.conf to match your tape drive parameters.  Some of the
>information is in the man page, the other stuff, specific to your tape
>drive, can probably be determined by looking in /proc/scsi.
>
>Hope it helps.
>
>-Dave
>
>  
>


