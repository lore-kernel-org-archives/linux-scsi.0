From: Ishikawa <ishikawa@yk.rim.or.jp>
Subject: Re: Ungraceful handling of scsi tape drive error condition
Date: Fri, 26 Jul 2002 11:52:56 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D40B988.6D24ACF@yk.rim.or.jp>
References: <m17Vcsl-000HcIC@standard.erephon>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yk.rim.or.jp (really [127.0.0.1]) by yk.rim.or.jp
	via smail with esmtp
	id <m17XvDw-000HA8C@standard.erephon> (Debian Smail3.2.0.114)
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2002 11:53:00 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Kai.Makisara@metla.fi, dc390@garloff.de, garloff@suse


Hi,

My own followup:

After a few e-mail exchanges with Kai Makisara,

 - I tried cleaning tape,

 - swapped SCSI card, etc..

I still saw strange errors.
The drive seemed to emit UNIT_ATTENTION
at unexpected times and the driver thought
the tape was gone and stopped writing.

Then I found out that the power supply
of the external SCSI enclosure that houses the
DDS2 tape drive has become unreliable.
Once I put the drive into another enclosure (with
presumably a good power supply), I could 
archive files successfully.

Obviously, the drive
behaved erratically due to the dying power 
supply( the power was there, but presumably
the voltage was fluctuating. ),
and even the best intention of the
drivers could not cope with such
dire situation.

The transient nature of the bad power supply
made it difficult to catch the real cause of
the problem initially.
(SCSI cable and terminator were suspected
but they are good after all.)
Honestly speaking this is the first time a power
supply of an external SCSI enclosure went bad
for me (I have used SCSI devices more than 15 years)
and so somehow I suspected power-supply very little
initially.
So maybe we should ask if power-supply 
is flakey when we see SCSI errors on top of the
usual suspects (cable, terminator, etc..).


Thank you all for helpful tips.

Chiaki
