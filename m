From: =?ISO-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>
Subject: New SYM-2 driver version for Linux-2.4.19
Date: Sun, 24 Nov 2002 21:40:17 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021124212349.O199-100000@localhost.my.domain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [192.168.1.129] (212.232.75.125) by mail.libertysurf.net (6.5.026)
        id 3DD89CB9001F106B for linux-scsi@vger.kernel.org; Sun, 24 Nov 2002 20:39:56 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hello,

I just made available my current version of the sym53c8xx_2 driver for
Linux. I have merged the changes from linux 2.4.19 and 2.5.45.

ftp://ftp.tux.org/pub/roudier/drivers/linux/stable/sym-2.1.19-pre3-for-=
linux-2.4.19.tar.gz

(Not sure the URL is full correct, but it shouldn't this wrong... :-))

There is also some code from me that has been added. ;)
Here is the ChangeLog addition:

	- Merge changes from linux-2.4.19 and linux-2.5.45.
	  Rearrange the code for the source to compile and run on both
	  Linux versions + some rewrites for the code to look good to me ;).
	- Add enough #if's for the smp locking to be source compatible for
	  both Linux branches.
	- Move all the nvram related definitions to a separate header file
	  and add the code that allows to write to the NVRAM.
	- Rearrange the code in function sym_snooptest().
	- Test against DMA ressource shortage and return error condition
	  if such happens (the scatter code has been slightly rewritten).
	- Add a new  errata work-around for all C10*0 chips (SCNTL3 register
	  must not be altered when REQs occurs on the SCSI BUS).
	  A copy of the 'select' table (alt_sel) has been added in the CCB
	  for this work-around.
	- A couple of minor changes + some typo fixes.

The code should also compile and run under Linux 2.5.45. I don't know f=
or
now if it is compatible with any prior or further 2.5 branch kernel
version. I will resync with current linux SCSI as soon as I will have t=
ime
for.

You may let me know if you encounter problems with this new driver
version. Thanks.

  G=E9rard.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
