From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Seagate Cheetah: Firmware, Bugs, Compatibility?
Date: Mon, 6 Jan 2003 07:51:55 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D4F1@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from petasus.fm.intel.com (petasus.fm.intel.com [10.1.192.37])
	by hermes.fm.intel.com (8.11.6/8.11.6/d: outer.mc,v 1.51 2002/09/23 20:43:23 dmccart Exp $) with ESMTP id h06Fksd22513
	for <linux-scsi@vger.kernel.org>; Mon, 6 Jan 2003 15:46:54 GMT
Received: from fmsmsxvs041.fm.intel.com (fmsmsxvs041.fm.intel.com [132.233.42.126])
	by petasus.fm.intel.com (8.11.6/8.11.6/d: inner.mc,v 1.27 2002/10/16 23:46:59 dmccart Exp $) with SMTP id h06FiaE23831
	for <linux-scsi@vger.kernel.org>; Mon, 6 Jan 2003 15:44:36 GMT
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Jones' <dmjones@ix.netcom.com>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Linux-SCSI <linux-scsi@vger.kernel.org>

Mikael,

For your own system, you know when it is really idle, so you can do it when
you wish.  

The recommended way to do this on a production system (assuming some kind of
RAID) is to take one disk out of the raid, update its firmware, add it back
to the raid, then do the same to the next one.  This can all be scripted,
and even if it takes a bit longer, it's worth it to most HA customers to
keep the system running throughout the update.

Each OS is different in handling live disk firmware updates.  Some OSs
handle the 'not ready' sense condition while the download is happening
robustly enough so that it can be done almost at will.  Most disk vendors
only support DOS tools, because that's the easiest way.  

Andy

-----Original Message-----
From: Dan Jones [mailto:dmjones@ix.netcom.com] 
Sent: Saturday, January 04, 2003 5:24 PM
To: Mikael Abrahamsson
Cc: Linux-SCSI
Subject: Re: Seagate Cheetah: Firmware, Bugs, Compatibility?


Mikael Abrahamsson wrote:
> 
> On Fri, 3 Jan 2003, Cress, Andrew R wrote:
> 
> It's not clear from the docs if it's a good idea to flash the drives when
> the system is up and running normally, any comments on that?
> 

Yes, never flash a drive that is not idle. A real-time update to running
code 
is not trivial and drive vendors don't support it.

-- 
Dan Jones           "'Tis hard to say, if greater want of skill
                     Appear in writing or in judging ill;
                     But of the two, less dangerous is th' offence 
                     To tire our patience, than mislead our sense." Pope
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
