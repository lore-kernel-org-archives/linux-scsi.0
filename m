From: Steven Dake <sdake@mvista.com>
Subject: Re: scsi bus-reset in qlogic causes system stall
Date: Fri, 17 Jan 2003 11:32:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E284C40.3060701@mvista.com>
References: <20030117182013.22919.qmail@web20422.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030117182013.22919.qmail@web20422.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: devnetfs <devnetfs@yahoo.com>
Cc: linux-scsi@vger.kernel.org

bug in qlogic driver I think this has been fixed to a schedule_timeout 
in the 6.X drivers (from a spin on i/o)

I have done this same thing with the 6.x driver and the system is still 
usable.  Keep in mind that the I/O's will retry until the FC LIP has 
completed.

Thanks
-steve

devnetfs wrote:

>Hello,
>
>I am running RedHat 2.4.9-13 with qlogic qla2x00 driver (ver 4.31.7b).
>Trying to do a bus-reset (in an multi-initiator, shared-scsi scenario)
>stalls one (or more) nodes in the system for a while. dmesg shows the
>message: "Waiting for LIP to complete...", on all nodes. Everything
>freezes for a while (around 10-40secs). It happens on UP/SMP both.
>
>Is this normal? or a bug in qlogic driver? 
>
>Thanks in advance for any insight,
>A.
>
>
>__________________________________________________
>Do you Yahoo!?
>Yahoo! Mail Plus - Powerful. Affordable. Sign up now.
>http://mailplus.yahoo.com
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>  
>

