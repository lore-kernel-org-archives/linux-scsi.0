From: Dan Jones <dmjones@ix.netcom.com>
Subject: Re: Seagate Cheetah: Firmware, Bugs, Compatibility?
Date: Sat, 04 Jan 2003 14:23:53 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E175EF9.CC23D03D@ix.netcom.com>
References: <Pine.LNX.4.44.0301041021180.3657-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Linux-SCSI <linux-scsi@vger.kernel.org>

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
