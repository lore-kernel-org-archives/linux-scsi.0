From: devnetfs <devnetfs@yahoo.com>
Subject: RE: what does RECOVERED ERROR sense key mean?
Date: Thu, 16 Jan 2003 21:34:10 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030117053410.1843.qmail@web20415.mail.yahoo.com>
References: <A5974D8E5F98D511BB910002A50A66470580D554@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <A5974D8E5F98D511BB910002A50A66470580D554@hdsmsx103.hd.intel.com>
List-Id: linux-scsi@vger.kernel.org
To: "Cress, Andrew R" <andrew.r.cress@intel.com>, linux-scsi@vger.kernel.org

Thanks for the answer :)

Yes I did notice that even if I get this error (say from node A)
the reservation seems to succeed as I get RESERVATION CONFLICT
while trying to RESERVE the same disk from node B.

Thanks,
A.

--- "Cress, Andrew R" <andrew.r.cress@intel.com> wrote:
> Yes, if you get the 01 sense key (recovered error), it has already
> recovered, so you should not retry.  The mode pages of the device can
> be set
> to report recovered errors or not, but usually it is desirable to
> report
> them so that the information can be used to predict when you need to
> do
> maintenance on the device, etc.
> 
> Andy Cress
> 
> -----Original Message-----
> From: devnetfs [mailto:devnetfs@yahoo.com] 
> Sent: Thursday, January 16, 2003 2:43 AM
> To: linux-scsi@vger.kernel.org
> Subject: what does RECOVERED ERROR sense key mean?
> 
> 
> Hello,
> 
> I am trying to reserve a disk using SCSI_IOCTL_SEND_COMMAND ioctl.
> 
> Sometimes I get SCSI error code=0x2 (ioctl returns this value). From 
> the "Linux SCSI Generic HOWTO", above code is a 4-byte compacted
> error 
> code. Here for 0x2 it means: status_byte == CHECK_CONDITION. The
> Sense
> Key I get is 0x1 i.e. "RECOVERED ERROR".
> 
> From the "SCSI Programming HOWTO", "RECOVERED ERROR" means:
> ---
> "Indicates that the last command completed successfully with some
> recovery action performed by the target. Details may be determinable 
> by examining the additional sense bytes and the information field.
> When multiple recovered errors occur during one command, the choice
> of
> which error to report (first, last, most severe, etc.) is device 
> specific."
> ---
> 
> So my question is: can I ASSUME that when I get this error(0x2) and
> sensekey (0x1) my RESERVER was successful? or should I again retry?
> 
> Thanks in Advance,
> A.
> 
> 
> __________________________________________________
> Do you Yahoo!?
> Yahoo! Mail Plus - Powerful. Affordable. Sign up now.
> http://mailplus.yahoo.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


__________________________________________________
Do you Yahoo!?
Yahoo! Mail Plus - Powerful. Affordable. Sign up now.
http://mailplus.yahoo.com
