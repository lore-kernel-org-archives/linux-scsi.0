From: "shankar krishna" <kshan01@hotmail.com>
Subject: Re: Interpreting SCSI CDB response over FC(FCP-2)
Date: Thu, 14 Nov 2002 10:49:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <F1071bgxXMa4we8dSwm0000c5ee@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

1.
"if ((res = ioctl(sd_fd,SCSI_IOCTL_SEND_COMMAND,&cdb_buf))) {
    scsi_status = res & 0xff;
    .....
}"

Thanks. Atleast able to get Status Byte.
Question out of curiosity: if I declare
'res' as int, the return value from ioctl
was 0x28000002 which obviously give 02(Check
condition) if "&" with "ff". But I want to know
what are all the other Octets?? Any meaning
attached to them?

2.
" The only way that I can see to get the
whole FCP response payload would be via an ioctl in the
lower level driver."

Where can I consult or get doc to see there is
any way I can send probe below Mid-level driver
(or even below?)

_________________________________________________________________
Protect your PC - get McAfee.com VirusScan Online 
http://clinic.mcafee.com/clinic/ibuy/campaign.asp?cid=3963

