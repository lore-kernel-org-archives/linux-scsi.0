From: Steven Dake <sdake@mvista.com>
Subject: Re: dev nodes assignement ?
Date: Wed, 29 Jan 2003 09:46:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E380583.4090609@mvista.com>
References: <20030129110004.22210.qmail@web20421.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030129110004.22210.qmail@web20421.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: devnetfs <devnetfs@yahoo.com>
Cc: linux-scsi@vger.kernel.org

first come first serve.  devfs defines the device nodes using access 
path (host/channel/id/lun) which is a bit more usable for hotswap 
situtations, assuming your id's don't change.

Thanks
-steve

devnetfs wrote:

>Hello,
>
>Is /dev/sdX scsi dev node assignment based *only* on the pci-slot
>the HBA's are in? or also upon the order in which the LLDD is loaded?
>
>In other words does the mid-layer scan+make-a-list of all HBA's on
>the system (and thereby assigning the /dev name) and then when a LLDD
>is loaded, tells it the HBA-list? 
>OR
>Does each LLDD does a pci-scan and assign /dev name for HBA's that it
>can handle -- in which case the order of LLDD getting loaded is also
>important in deciding the /dev/sdX name.
>
>Please clarify, 
>Thanks in advance
>A.
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

