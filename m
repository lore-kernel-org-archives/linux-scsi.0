From: David Ramirez Joya <dramirez@citi.com.mx>
Subject: Good afternoon to everyone. Question about PERC 4Di on Dell poweredge
 1750
Date: Thu, 10 Jun 2004 19:38:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40C8FEF9.5090106@citi.com.mx>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_IS_MIME_Boundary"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from correo.citi.com.mx ([200.34.113.57]:6901 "EHLO
	correo.citi.com.mx") by vger.kernel.org with ESMTP id S263645AbUFKAiS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jun 2004 20:38:18 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, mailman-owner@us.dell.com, Juan Antonio Garza Garza <jgarza@citi.com.mx>

--=_IS_MIME_Boundary
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

***************************
Dell Moderator: I Subscribed to the linux-scsi mailing list in order to 
send this message maybe it should be sent to another list _please_ help 
me and send it to the porper list if this is not the one.
***************************

Good afternoon to everyone. As in the info on the http://linux.dell.com 
says: Ask questions to the mailing list, I have a question to you.

I hope someone can help me!

Please bear with me, this is a quite looong message.

If you just want to help me please see the "The scenario" and "The 
Questions" parts.

*******************************
The scenario.
*******************************
I have a Dell Poweredge 1750 with the PERC 4Di SCSI controller.

I HAVE to install redhat 7.3 on this platform.
Now, for now I have no option but to install Redhat 7.3 o 7.2 on this 
server. This is because a software product requires the kernel version 
included in this distribution version. So, until I have the proof that 
it is not possible to install the product on this platform I cannot go 
to the vendor to upgrade its product to work in another kernel version.

******************************
What I have done:
******************************
I have downloaded the DKMS megaraid2-2.10.1 driver. I have managed to 
compile it with the kernel version 2.4.18-3.
Now I am not a programmer :-( just a sysadmin so what I did in order to 
the driver to compile, was to apply the patch for the RH 8 Kernel (I 
guess it was 2.4.18-20 or something). I apply this patch because by 
trying to generate the driver just with the 2.10.1 source code as 
included on the megaraid2-2.10.1 package the build just breaks.

So after I managed for the driver to compile, I mkdriverdisk with dkms, 
created the driver disk and I tried to make the driver to work with 
"linux dd". The driver diskette was "incompatible with this version of 
RedHat". I found out that there was missing the "- rh73" at the end of 
the modinfo an disk-info line which state the driver name... With this 
modification I managed to make RedHat 7.3 to "accept" the driver disk. 
But the module is not accepted.

I looked on the logs, the problem is RedHat knows that the Megaraid 
Driver needs a "Hardware SCSI" driver (I do not know how to call this) 
which is one of aacraid, aic7xxx then it looks for the megaraid2.o !!! 
driver on the BOOT Image of the redhat 7.3 Installation... Or so I 
think. (please correct me if I am wrong but I guess this is what happens 
on the boot sequence). Obviouly this driver will never be found because 
the megaraid driver included in RH7.3 is the 1.18a version which is 
named just as megaraid.o. So I  cannot go any further :-(. Just to be 
sure, I tried to insmod the bare megaraid2.o driver to the kernel on the 
RH7.3 install image I mean when the Installation drops a shell. But I 
get a lot of Unresolved Symbols. I gues this is because the aacraid nor 
the aic7xxx driver does not work so It cannot resolve the symbols it needs.

Now what I have is this.
I have to make a Dell poweredge 1750 to work with the stock kernel of 
RH7.3. I have a driver diskette with the Megaraid2.o (Ver 2.10.1) 
compiled (I don't know if it's safe to use it with the patch of the 
2.4.18-20 Or something) But the driver cannot load because nor the 
aacraid nor the aic7xxx driver cannot see the PERC 4Di device.


So what do I need? I have to do another aacraid or aic7xxx driver? 
(which by the way I wouldn't know how to do it because I haven't seen a 
method to make this driver using DKMS Nor that I have searched a lot ;-))

By the way I just notied today that there is a 1.18f megaraid driver 
version which I haven't tested (because the server is in another 
physical location). Maybe that could be my answer but Again, I haven't 
tested it on the Server. (I do not know if the aacraid or the aic7xxx 
driver will now work but i have to test it to know).

so after all of this information here are my questions PLEASE HELP!!!

****************************************
The questions
****************************************
I KNOW that RH7.3 IS NOT SUPPORTED for the Dell 1750 but I REALLY need 
to know if it is possible to get it to work.

Please tell me. A sysadmin without any programming ability has the 
option to get it to work?

If yes, please send me a clue on how to do it!!! Do I need to recompile 
the megaraid2 driver with special options? Do I have to recreate the 
accraid driver? aic7xxx driver??? A special patch not publicy 
disclosed??? :-S

If not. Please tell me. Is it not possible to get  RH7.3 to work with 
the Dell poweredge 1750 because there is no driver for "..." and It is 
not possible to create it.
So I can go to the vendor and ASK him to make his product to work in 
another kernel version.

ANY help would be REALLY appreciated!!!

Thanks in advance to all of you for the answer.

Best regards,

David Ramírez Joya.

-- 
Ing. David Ramírez Joya	
Security Consultant
C I T I
Tel. (52) 81 82 89 32 00 x 135
Fax. 82 89 32 01
e-mail: dramirez@citi.com.mx
web: http://www.citi.com.mx


--=_IS_MIME_Boundary--
