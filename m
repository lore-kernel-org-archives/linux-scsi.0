From: Mathieu Chouquet-Stringer <mathieu@newview.com>
Subject: Re: ANNOUNCE: saftemon - SCSI Enclosure monitor for linux
Date: 17 Apr 2002 11:23:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <xltu1qa1h90.fsf@shookay.newview.com>
References: <71714C04806CD51193520090272892170452B669@ausxmrr502.us.dell.com> <xlt7kn62wmq.fsf@shookay.newview.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nystorage01.e-steel.com (nystorage01.e-steel.com [192.168.1.62])
	by nymail01.e-steel.com (8.11.4/8.11.2) with ESMTP id g3HFNN112976
	for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2002 11:23:23 -0400 (EDT)
Received: (from news@localhost)
	by nystorage01.e-steel.com (8.9.3+Sun/8.9.3) id LAA10978
	for linux-scsi@vger.kernel.org; Wed, 17 Apr 2002 11:23:22 -0400 (EDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Michael Clark <michael@metaparadigm.com>

mathieu@newview.com (Mathieu Chouquet-Stringer) writes:
> Tested it too on my server and it works perfectly. Congratulations!
> 
> Cheers, Mathieu.

Well I spoke probably too fast. It work perfectly but only once...
Here's what I got (using saftemon -p):

Found 1 SAF-TE devices
SAF-TE Device DELL 1x8 U2W SCSI BP (2:0:6:0)
no. of fans           = 3
no. of power supplies = 0
no. of device slots   = 8
door lock installed   = 0
no. of temp sensors   = 2
audible alarm         = 0
no. of thermostats    = 0
fan 0 is operational
fan 1 is operational
fan 2 is operational
device slot 0 disk present,active,no error
device slot 1 disk present,active,no error
device slot 2 disk present,active,no error
device slot 3 disk present,active,no error
device slot 4 disk present,active,no error
device slot 5 disk present,active,no error
device slot 6 disk present,active,no error
device slot 7 disk present,active,no error
temp sensor 0 is 26.1 c and okay
temp sensor 1 is 26.7 c and okay
overall temperature is okay

Third tries, I got this:

Found 1 SAF-TE devices
SAF-TE Device DELL 1x8 U2W SCSI BP (2:0:6:0)
no. of fans           = 0
no. of power supplies = 0
no. of device slots   = 2
door lock installed   = 0
no. of temp sensors   = 32
audible alarm         = 0
no. of thermostats    = 0
device slot 0 disk not present
device slot 1 insert ready,parity check
temp sensor 0 is -5.6 c and okay
temp sensor 1 is -23.3 c and okay
temp sensor 2 is -23.3 c and okay
temp sensor 3 is 4.4 c and okay
temp sensor 4 is 19.4 c and okay
temp sensor 5 is 32.8 c and okay
temp sensor 6 is 33.9 c and okay
temp sensor 7 is 30.6 c and okay
temp sensor 8 is 22.2 c and okay
temp sensor 9 is 12.8 c and okay
temp sensor 10 is 17.2 c and okay
temp sensor 11 is 14.4 c and okay
temp sensor 12 is 18.9 c and okay
temp sensor 13 is 14.4 c and okay
temp sensor 14 is 3.3 c and okay
temp sensor 15 is -5.6 c and okay
temp sensor 16 is 0.0 c and okay
temp sensor 17 is 0.0 c and okay
temp sensor 18 is 0.0 c and okay
temp sensor 19 is 0.0 c and okay
temp sensor 20 is 0.0 c and okay
temp sensor 21 is 0.0 c and okay
temp sensor 22 is 0.0 c and okay
temp sensor 23 is 0.0 c and okay
temp sensor 24 is 0.0 c and okay
temp sensor 25 is 0.0 c and okay
temp sensor 26 is 0.0 c and okay
temp sensor 27 is 0.0 c and okay
temp sensor 28 is 0.0 c and okay
temp sensor 29 is 0.0 c and okay
temp sensor 30 is 0.0 c and okay
temp sensor 31 is 0.0 c and okay
overall temperature is okay

zsh: 24211 segmentation fault  saftemon -p

And now the daemon refuses to start and I have got this in the saftemon
logfile:
Wed Apr 17 11:18:06 2002 [25319] *** saftemon-0.0.4 starting
Wed Apr 17 11:18:06 2002 [25319] No SAF-TE devices present. exiting

Let me know if you want me to provide more data.

Regards, Mathieu.

-- 
Mathieu Chouquet-Stringer              E-Mail : mathieu@newview.com
    It is exactly because a man cannot do a thing that he is a
                      proper judge of it.
                      -- Oscar Wilde
