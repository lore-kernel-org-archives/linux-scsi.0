From: Sumit Agarwal <aksumit@india.hp.com>
Subject: Re: building SCSI CDB over FC
Date: Fri, 08 Nov 2002 11:52:58 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DCBF9FA.AF7B2C19@india.hp.com>
References: <F393oHMwVN7miR9Odut000000b9@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------082D2F606B5DDA3138B35F8B"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: shankar krishna <kshan01@hotmail.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------082D2F606B5DDA3138B35F8B
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Check the r_ctl bits of your FCP CDB while generating your
FCP IU. It should be unsolicited command. The best way to
send your commands are using ioctl's so try to use them.

Thanks
- Sumit

shankar krishna wrote:
> 
> Hi,
> 
> I am trying to send SCSI CDB over Fibre channel HBA.
> 
> Using IBM FC disk drive and qlogic HBA(QLA2300).
> 
> I want to build my own CDB (not with 'write' cmd which
> sends an "ex write" to target) - eventually to build some
> vendor specific CDBs!
> 
> Can anybody help me in this?
> 
> Rgds,
> -Shankar.
> PS: I am using FC analyser(FCacccess) inbetween Drive and HBA to
> see the frames and their contents. If I do a "write"
> of my own CDB, it sends it as data not as a command!!
> 
> _________________________________________________________________
> MSN 8 helps eliminate e-mail viruses. Get 2 months FREE*.
> http://join.msn.com/?page=features/virus
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--------------082D2F606B5DDA3138B35F8B
Content-Type: text/x-vcard; charset=us-ascii;
 name="aksumit.vcf"
Content-Transfer-Encoding: 7bit
Content-Description: Card for Sumit Agarwal
Content-Disposition: attachment;
 filename="aksumit.vcf"

begin:vcard 
n:Agarwal;Sumit
tel;fax:(91)(80)2200196
tel;home:+919845205210
tel;work:2051126
x-mozilla-html:FALSE
url:www.hp.com
org:HP-ISO;HPUX
version:2.1
email;internet:aksumit@india.hp.com
title:Senior Software Engineer
adr;quoted-printable:;;Hewlett-Packard,=0D=0AIndia Software Operation Pvt. Ltd.,=0D=0A29, Cunningham Road,=0D=0A;Bangalore;Karnataka;560052;India
fn:Sumit Agarwal
end:vcard

--------------082D2F606B5DDA3138B35F8B--

