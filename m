From: "Nirmala S" <nmala@mail.com>
Subject: RE: Issuing SCSI command 'MODE SENSE'
Date: Tue, 12 Nov 2002 10:08:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021112150845.32341.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: "Cress, Andrew R" <andrew.r.cress@intel.com>, linux-scsi@vger.kernel.org

Hi,

Thanks for the reply.

I have found some code :

LEN = 480
cdb[1] = (((dev_id & 0xF00) >> 8) << 5)
cdb[7] = ((480 >> 8) & 0xff)
cdb[8] = (480 & 0xff)

Any idea why it is 'anded' with 255. Can't seem to understand how the lun value is calculated.

Any idea ??

Thanks and Regards,
Mala

----- Original Message -----
From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Date: Tue, 12 Nov 2002 06:01:10 -0800
To: "''Nirmala S''" <nmala@mail.com>, linux-scsi@vger.kernel.org
Subject: RE: Issuing SCSI command 'MODE SENSE'


> Mala,
> 
> The LUN should be passed in as part of the host:chan:targ:lun addressing.
> Use SCSI_IOCTL_GET_IDLUN to return it.  
> 
> If you are building a utility, I have some code that shows this and the
> length stuff for mode sense, see http://scsirastools.sourceforge.net
> (sgmode.c & sgsub.c).
> 
> scsiinfo is another open-source tool that shows mode sense usage.
> 
> Andy
> 
> -----Original Message-----
> From: Nirmala S [mailto:nmala@mail.com] 
> Sent: Tuesday, November 12, 2002 8:38 AM
> To: linux-scsi@vger.kernel.org
> Subject: Issuing SCSI command 'MODE SENSE'
> 
> 
> Hi,
> 
> While using the MODE SENSE command how does one calculate the "Allocation
> Length" MSB, LSB, the LUN no. and the length of the data returned by the
> command.
> 
> Kindly let me know.
> 
> Thanks and Regards,
> Mala
> -- 
> __________________________________________________________
> Sign-up for your own FREE Personalized E-mail at Mail.com
> http://www.mail.com/?sr=signup
> 
> Single & ready to mingle? lavalife.com:  Where singles click. Free to
> Search!
> http://www.lavalife.com/mailcom.epl?a=2116
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
__________________________________________________________
Sign-up for your own FREE Personalized E-mail at Mail.com
http://www.mail.com/?sr=signup

Single & ready to mingle? lavalife.com:  Where singles click. Free to Search!
http://www.lavalife.com/mailcom.epl?a=2116

