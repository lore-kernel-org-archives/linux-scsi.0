From: "David Horton" <dhorton@megsinet.net>
Subject: Re: Problems with SCSI device
Date: Wed, 26 Mar 2003 12:13:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200303261713.h2QHDXLr090443@mail5.mx.voyager.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: gmartin@filmayer.es
Cc: linux-scsi <linux-scsi@vger.kernel.org>

>   Hi again,
> 
> thanks Dave. No the conection with the device doesn't hang. But I still 
> have problems. When I try to initialize the device I get the following 
> error:
> 
>     The SCSI INQUIRY for device '/dev/nst0' failed (power off?)
>     Definition for '/dev/st0' failed.
> 
> What it can be this time? I have created and configured the stinit.def   
> file (not .conf file 'cause in the man page for stinit is the file that 
> sugests)  as you told me. I don't know if it is well configured because 
> I don't have the specifications of my drive.
> 
> Does any one of you have any idea of where the problem can be?
> 
> Thanks,
> GUSTAVO

You are right, it is stinit.def.  Anyway, when I set up my DAT drive I
used a combination of info from /proc/scsi and HP's website.

You can put in your product number at hp.com's support & driver's
section and probably dig up a .PDF manual.  The HP Tape Tools is also
helpful, but I think it only runs on Windows.

As for /proc/scsi, that's where you can find parameters that you will
need for stinit.def such as 'manufacturer' and 'model'.  Wrong info here
could be causing some trouble.  For example, even though I have a
product labeled "HP SureStore 5000" I have to put model "HP35480A" in
stinit.def, because that is the generic name shown in /proc/scsi. 
Otherwise stinit never initializes the tape drive because it can't find it.

-Dave




