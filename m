From: "Ming Zhang" <mingz@ele.uri.edu>
Subject: Re: Re: about scsi_hostlist
Date: Sun, 17 Nov 2002 17:35:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211172237.gAHMbF99022232@leviathan.ele.uri.edu>
Mime-Version: 1.0
Content-Type: text/plain;
      charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi, Doug

For example, like the iSCSI target code, when it start, it should find all SCSI disks or tapes link in order to export to client side. It need the scsi_device pointer in order to send requests to it. That is why I need it. Is there a formal way to find a scsi_device pointer by its lun, host id, ... or by block layer major number and minor number?

thx.



======= At 2002-11-17, 17:30:00 you wrote: =======

>On Sun, Nov 17, 2002 at 05:11:28PM -0500, Ming Zhang wrote:
>> Hi, I meet a problem when port my code to 2.5.47.
>> My goal is to get all scsi disk Scsi_Device pointers.
>
>Why?  A couple people on this list have been trying to put proper object 
>ref counting in place, and doing this sort of thing usually violates those 
>ref counting rules, so unless you have a true valid need to do this, the 
>answer is probably going to be "Don't do that".
>
>> For 2.4.18, I can use scsi_hostlist to travel through the list and get all pointer by comparing type if TYPE_DISK. But in 2.5.47, there is no such pointer. And that scsi_host_list can not be used.
>> 
>> Does anyone know how to get around to this? 
>> 
>> Thanks in advance.
>> 
>> 
>> 
>> Best regards. 
>> 
>> 
>> Ming Zhang
>> ------------------------------
>> Member of IEEE, ACM
>> mingz@ele.uri.edu
>> http://www.ele.uri.edu/~mingz
>> 1(401)874-4859
>> 
>> Department of Electrical and Computer Engineering
>> University of Rhode Island
>> 
>> 4 East Alumni Ave. Kingston, RI, 02881
>> 
>> 
>> 
>> 
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>-- 
>  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
>         Red Hat, Inc. 
>         1801 Varsity Dr.
>         Raleigh, NC 27606
>  
>
>.

= = = = = = = = = = = = = = = = = = = =
			

Best regards.				 


Ming Zhang
------------------------------
Member of IEEE, ACM
mingz@ele.uri.edu
http://www.ele.uri.edu/~mingz
1(401)874-4859

Department of Electrical and Computer Engineering
University of Rhode Island

4 East Alumni Ave. Kingston, RI, 02881




